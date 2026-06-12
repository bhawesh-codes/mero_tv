// lib/ui/views/video_player/video_player_viewmodel.dart
import 'dart:async';
import 'package:better_player_enhanced/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mero_tv/app/app.locator.dart';
import 'package:mero_tv/models/channel_model.dart';
import 'package:mero_tv/services/channel_player_service.dart';
import 'package:mero_tv/ui/views/favorites/services/favorites_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class VideoPlayerViewModel extends BaseViewModel with WidgetsBindingObserver {
  final _navigationService = locator<NavigationService>();
  final _channelPlayerService = locator<ChannelPlayerService>();
  final _favoritesService = locator<FavoritesService>();
  static const _pipChannel = MethodChannel('mero_tv/pip');

  BetterPlayerController? _controller;
  BetterPlayerController? get controller => _controller;

  GlobalKey? _betterPlayerKey;

  bool containsError = false;
  String? errorMessage;
  bool _isDisposed = false;
  bool _isPlayerReady = false;
  bool _isRetrying = false;
  bool _isInPip = false;
  bool _isSwitching = false;
  String? _currentUrl;
  Timer? _bufferingTimer;
  Timer? _retryDebounce;
  Timer? _loadTimeoutTimer;
  Timer? _channelSwitchDebounce;

  // Simple cooldown lock - prevents rapid controller churn
  bool _channelChangeLocked = false;

  // Load token prevents stale loads from winning races
  int _loadToken = 0;

  // Local copy from service so we don't mutate the service mid-session
  late List<ChannelModel> _channelList;
  late int _currentIndex;

  bool get isPlayerReady =>
      _isPlayerReady && _controller != null && !containsError;
  bool get isInPip => _isInPip;
  bool get isSwitching => _isSwitching;

  String get currentTitle =>
      _channelList.isNotEmpty ? (_channelList[_currentIndex].name ?? '') : '';

  // ── Favorites ─────────────────────────────────────────────────────────────

  ChannelModel? get currentChannel =>
      _channelList.isNotEmpty ? _channelList[_currentIndex] : null;

  bool get isCurrentFavorite {
    final channel = currentChannel;
    if (channel == null) return false;
    return _favoritesService.isFavorite(channel);
  }

  Future<void> toggleCurrentFavorite() async {
    final channel = currentChannel;
    if (channel == null) return;
    await _favoritesService.toggleFavorite(channel);
    notifyListeners();
  }

  // ── Init ──────────────────────────────────────────────────────────────────

  Future<void> init(String url) async {
    _currentUrl = url;
    _channelList = List.from(_channelPlayerService.channelList);
    _currentIndex = _channelPlayerService.currentIndex;

    await WakelockPlus.enable();
    WidgetsBinding.instance.addObserver(this);
    _pipChannel.setMethodCallHandler(_handleNativeMethod);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_isDisposed) return;
      await _initializePlayer(url);
    });
  }

  void setBetterPlayerKey(GlobalKey key) {
    _betterPlayerKey = key;
  }

  // ── Channel switching with DEBOUNCE + COOLDOWN ─────────────────────────────

  Future<void> switchToNext() async {
    if (_channelList.isEmpty) return;
    final nextIndex = _currentIndex + 1;
    if (nextIndex >= _channelList.length) return;
    _queueSwitchToIndex(nextIndex);
  }

  Future<void> switchToPrevious() async {
    if (_channelList.isEmpty) return;
    final prevIndex = _currentIndex - 1;
    if (prevIndex < 0) return;
    _queueSwitchToIndex(prevIndex);
  }

  void _queueSwitchToIndex(int index) {
    if (_isDisposed) return;

    // Debounce: cancel previous pending switch
    _channelSwitchDebounce?.cancel();

    // Update UI immediately for responsive feel
    _currentIndex = index;
    notifyListeners();

    // Wait 600ms, then execute if no newer swipe came in
    _channelSwitchDebounce = Timer(
      const Duration(milliseconds: 600),
      () {
        if (_isDisposed) return;
        _executeSwitchToIndex(index);
      },
    );
  }

  Future<void> _executeSwitchToIndex(int index) async {
    // Cooldown check - prevents rapid controller churn
    if (_channelChangeLocked) {
      debugPrint('📺 Cooldown active, ignoring switch to $index');
      return;
    }

    final channel = _channelList[index];
    if (channel.streamUrl == null) return;

    // Set cooldown lock
    _channelChangeLocked = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      _channelChangeLocked = false;
      debugPrint('📺 Cooldown ended');
    });

    debugPrint('📺 Switching to channel: ${channel.name} (${index})');

    _isSwitching = true;
    _currentUrl = channel.streamUrl;
    containsError = false;
    errorMessage = null;
    _isPlayerReady = false;
    notifyListeners();

    _bufferingTimer?.cancel();
    _retryDebounce?.cancel();
    _loadTimeoutTimer?.cancel();

    // Increment load token to invalidate stale loads
    final currentToken = ++_loadToken;

    // Save reference to old controller BEFORE setting to null
    final oldController = _controller;

    // Set to null FIRST so events are ignored
    _controller = null;

    // Then dispose the old controller
    if (oldController != null) {
      await _silentDispose(oldController);
    }

    _isSwitching = false;

    if (_isDisposed) return;

    await _initializePlayerWithToken(channel.streamUrl!, currentToken);
  }

  // ── PiP ───────────────────────────────────────────────────────────────────

  Future<dynamic> _handleNativeMethod(MethodCall call) async {
    if (call.method == 'onPipChanged') {
      final bool isInPip = call.arguments['isInPip'] as bool;
      _isInPip = isInPip;
      // If exiting PiP, ensure playback resumes
      if (!isInPip && _controller != null && !_isDisposed) {
        try {
          _controller!.play();
        } catch (_) {}
      }
      notifyListeners();
    }
    return null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || _isDisposed) return;

    // IMPORTANT: PiP is now handled by native onUserLeaveHint in MainActivity.kt
    // So we DON'T trigger PiP here anymore.
    // Only handle play/resume when app comes back to foreground.

    if (state == AppLifecycleState.resumed) {
      // App came back to foreground (either from PiP or from background)
      _isInPip = false;
      if (_controller != null && !_isDisposed && _isPlayerReady) {
        try {
          _controller!.play();
        } catch (_) {}
      }
      notifyListeners();
    }
    // Do NOT trigger PiP on inactive or paused states - let native handle it
  }
  // Add this method to your ViewModel class (VideoPlayerViewModel)

  Future<void> enablePip() async {
    if (_controller == null || _betterPlayerKey == null || _isDisposed) return;
    try {
      await _pipChannel.invokeMethod('enterPip');
    } catch (e) {
      debugPrint('⚠️ Native PiP failed: $e');
    }
  }

  // ── Player init with TOKEN protection ──────────────────────────────────────

  Future<void> _initializePlayerWithToken(String url, int token) async {
    if (_isDisposed || token != _loadToken) return;

    _loadTimeoutTimer?.cancel();
    _loadTimeoutTimer = Timer(const Duration(seconds: 45), () {
      if (_isDisposed || _isRetrying || _isPlayerReady) return;
      if (token != _loadToken) return;
      _bufferingTimer?.cancel();
      _handleError('Unable to stream this channel.');
    });

    try {
      final dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        url,
        liveStream: true,
        videoExtension: 'm3u8',
        bufferingConfiguration: const BetterPlayerBufferingConfiguration(
          minBufferMs: 10000,
          maxBufferMs: 15000,
          bufferForPlaybackMs: 1500,
          bufferForPlaybackAfterRebufferMs: 10000,
        ),
        cacheConfiguration: const BetterPlayerCacheConfiguration(
          useCache: false,
        ),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
        notificationConfiguration: const BetterPlayerNotificationConfiguration(
          showNotification: false,
        ),
      );

      final controller = BetterPlayerController(
        const BetterPlayerConfiguration(
          autoPlay: true,
          fit: BoxFit.contain,
          handleLifecycle: true,
          autoDispose: true,
          allowedScreenSleep: false,
          fullScreenByDefault: false,
          useRootNavigator: true,
          placeholderOnTop: false,
          showPlaceholderUntilPlay: false,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            enablePip: false,
            enableFullscreen: true,
            enableMute: true,
            enablePlayPause: true,
            enableProgressBar: false,
            enableSkips: false,
            showControlsOnInitialize: false,
            controlBarColor: Color.fromARGB(56, 0, 0, 0),
            iconsColor: Colors.white,
            textColor: Colors.white,
            liveTextColor: Colors.red,
            loadingColor: Colors.white,
          ),
        ),
      );

      controller.addEventsListener(_onPlayerEvent);
      await controller.setupDataSource(dataSource);

      // Check if this load is still valid
      if (_isDisposed || token != _loadToken) {
        await _silentDispose(controller);
        return;
      }

      _controller = controller;
      _isPlayerReady = true;
      containsError = false;
      errorMessage = null;
      try {
        await _pipChannel.invokeMethod('setPipEnabled', true);
      } catch (_) {}
      notifyListeners();

      debugPrint('✅ Player ready for token $token');
    } catch (e) {
      if (token != _loadToken) return;

      if (!_isDisposed) {
        String userMessage = 'Unable to play this stream.';
        if (e.toString().contains('Network')) {
          userMessage = 'Network error. Check your internet connection.';
        } else if (e.toString().contains('404') ||
            e.toString().contains('not found')) {
          userMessage = 'Stream not available.';
        }
        _handleError(userMessage);
      }
    }
  }

  Future<void> _initializePlayer(String url) async {
    final token = ++_loadToken;
    await _initializePlayerWithToken(url, token);
  }

  void _onPlayerEvent(BetterPlayerEvent event) {
    // CRITICAL: Ignore ALL events if:
    // 1. ViewModel is disposed
    // 2. No controller exists (already disposed or not set)
    if (_isDisposed || _controller == null) return;

    if (event.betterPlayerEventType == BetterPlayerEventType.play ||
        event.betterPlayerEventType == BetterPlayerEventType.progress) {
      _loadTimeoutTimer?.cancel();
      if (containsError) {
        containsError = false;
        errorMessage = null;
        if (_controller != null && !_isDisposed) {
          notifyListeners();
        }
      }
      _bufferingTimer?.cancel();
      return;
    }

    switch (event.betterPlayerEventType) {
      case BetterPlayerEventType.bufferingStart:
        _bufferingTimer?.cancel();
        _bufferingTimer = Timer(const Duration(seconds: 10), () {
          if (_isDisposed || _isRetrying || _controller == null) return;
          _scheduleRetry();
        });
        break;
      case BetterPlayerEventType.bufferingEnd:
        _bufferingTimer?.cancel();
        _retryDebounce?.cancel();
        break;
      case BetterPlayerEventType.exception:
        _bufferingTimer?.cancel();
        if (!_isRetrying && _controller != null) {
          _handleError('Stream playback failed. Please try again.');
        }
        break;
      case BetterPlayerEventType.finished:
        _bufferingTimer?.cancel();
        if (_controller != null) {
          _handleError('Stream ended.');
        }
        break;
      case BetterPlayerEventType.initialized:
        if (containsError && _controller != null) {
          containsError = false;
          errorMessage = null;
          if (!_isDisposed && _controller != null) {
            notifyListeners();
          }
        }
        break;
      default:
        break;
    }
  }

  void _scheduleRetry() {
    if (_controller == null) return;

    _retryDebounce?.cancel();
    _retryDebounce = Timer(const Duration(milliseconds: 300), () {
      if (!_isDisposed &&
          !_isRetrying &&
          !containsError &&
          _controller != null) {
        retry();
      }
    });
  }

  Future<void> retry() async {
    if (_isDisposed ||
        _isRetrying ||
        _currentUrl == null ||
        _controller == null) {
      return;
    }

    _isRetrying = true;
    _bufferingTimer?.cancel();
    _retryDebounce?.cancel();
    _loadTimeoutTimer?.cancel();
    containsError = false;
    errorMessage = null;
    notifyListeners();

    final oldController = _controller;
    _controller = null;
    _isPlayerReady = false;
    await _silentDispose(oldController);
    await Future.delayed(const Duration(milliseconds: 500));

    _isRetrying = false;
    if (_isDisposed) return;
    await _initializePlayer(_currentUrl!);
  }

  void _handleError(String message) {
    if (_isDisposed || _isRetrying) return;
    _bufferingTimer?.cancel();
    _loadTimeoutTimer?.cancel();
    containsError = true;
    errorMessage = message;
    _isPlayerReady = false;
    notifyListeners();
  }

  Future<void> _silentDispose(BetterPlayerController? c) async {
    if (c == null) return;

    try {
      // STEP 1: Remove event listener IMMEDIATELY
      c.removeEventsListener(_onPlayerEvent);

      // STEP 2: Small delay to let any pending events process
      await Future.delayed(const Duration(milliseconds: 50));

      // STEP 3: Pause playback
      try {
        await c.pause();
      } catch (e) {
        // Ignore pause errors
      }

      // STEP 4: Wait for hardware
      await Future.delayed(const Duration(milliseconds: 200));

      // STEP 5: Finally dispose
      c.dispose();

      debugPrint('✅ Controller disposed cleanly');
    } catch (e) {
      debugPrint('Dispose error (safe to ignore): $e');
    }
  }

  Future<void> disposePlayer() async {
    if (_isDisposed) return;
    _isDisposed = true;
    _channelSwitchDebounce?.cancel();
    await WakelockPlus.disable();
    try {
      await _pipChannel.invokeMethod('setPipEnabled', false);
    } catch (_) {}
    WidgetsBinding.instance.removeObserver(this);
    _pipChannel.setMethodCallHandler(null);
    _bufferingTimer?.cancel();
    _retryDebounce?.cancel();
    _loadTimeoutTimer?.cancel();
    final c = _controller;
    _controller = null;
    _isPlayerReady = false;
    await _silentDispose(c);
  }

  void navigateBack() {
    disposePlayer();
    _navigationService.back();
  }

  @override
  void dispose() {
    disposePlayer();
    super.dispose();
  }
}
