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
  Timer? _pipTriggerTimer;
  Timer? _loadTimeoutTimer;

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
    // Pull channel list from shared service
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

  // ── Channel switching ──────────────────────────────────────────────────────

  Future<void> switchToNext() async {
    if (_channelList.isEmpty || _isSwitching) return;
    final nextIndex = _currentIndex + 1;
    if (nextIndex >= _channelList.length) return;
    await _switchToIndex(nextIndex);
  }

  Future<void> switchToPrevious() async {
    if (_channelList.isEmpty || _isSwitching) return;
    final prevIndex = _currentIndex - 1;
    if (prevIndex < 0) return;
    await _switchToIndex(prevIndex);
  }

  Future<void> _switchToIndex(int index) async {
    if (_isDisposed || _isSwitching) return;
    final channel = _channelList[index];
    if (channel.streamUrl == null) return;

    _isSwitching = true;
    _currentIndex = index;
    _currentUrl = channel.streamUrl;
    containsError = false;
    errorMessage = null;
    _isPlayerReady = false;
    notifyListeners();

    _bufferingTimer?.cancel();
    _retryDebounce?.cancel();
    _loadTimeoutTimer?.cancel();

    _isSwitching = false;
    if (_isDisposed) return;

    await _initializePlayer(channel.streamUrl!);
  }

  // ── PiP ───────────────────────────────────────────────────────────────────

  Future<dynamic> _handleNativeMethod(MethodCall call) async {
    if (call.method == 'onPipChanged') {
      final bool isInPip = call.arguments['isInPip'] as bool;
      _isInPip = isInPip;
      notifyListeners();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || _isDisposed) return;

    if (state == AppLifecycleState.inactive) {
      _pipTriggerTimer?.cancel();
      _pipTriggerTimer = Timer(const Duration(milliseconds: 600), () {
        if (!_isDisposed && !_isInPip) enablePip();
      });
    } else if (state == AppLifecycleState.resumed) {
      _pipTriggerTimer?.cancel();
      _isInPip = false;
      _controller!.play();
      notifyListeners();
    } else if (state == AppLifecycleState.paused) {
      _pipTriggerTimer?.cancel();
    }
  }

  Future<void> enablePip() async {
    if (_controller == null || _betterPlayerKey == null) return;
    try {
      await _pipChannel.invokeMethod('enterPip');
    } catch (e) {
      debugPrint('⚠️ Native PiP failed: $e');
    }
  }

  // ── Player init ───────────────────────────────────────────────────────────

  Future<void> _initializePlayer(String url) async {
    if (_isDisposed) return;

    // Start a 45s timeout — if the stream never becomes playable
    // (no 'play'/'progress' event), show an error.
    _loadTimeoutTimer?.cancel();
    _loadTimeoutTimer = Timer(const Duration(seconds: 45), () {
      if (_isDisposed || _isRetrying || _isPlayerReady) return;
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

      if (_isDisposed) {
        _silentDispose(controller);
        return;
      }

      _controller = controller;
      _isPlayerReady = true;
      containsError = false;
      errorMessage = null;
      await _pipChannel.invokeMethod('setPipEnabled', true);
      notifyListeners();
    } catch (e) {
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

  void _onPlayerEvent(BetterPlayerEvent event) {
    if (_isDisposed) return;

    if (event.betterPlayerEventType == BetterPlayerEventType.play ||
        event.betterPlayerEventType == BetterPlayerEventType.progress) {
      _loadTimeoutTimer?.cancel();
      if (containsError) {
        containsError = false;
        errorMessage = null;
        notifyListeners();
      }
      _bufferingTimer?.cancel();
      return;
    }

    switch (event.betterPlayerEventType) {
      case BetterPlayerEventType.bufferingStart:
        _bufferingTimer?.cancel();
        _bufferingTimer = Timer(const Duration(seconds: 10), () {
          if (_isDisposed || _isRetrying) return;
          _scheduleRetry();
        });
        break;
      case BetterPlayerEventType.bufferingEnd:
        _bufferingTimer?.cancel();
        _retryDebounce?.cancel();
        break;
      case BetterPlayerEventType.exception:
        _bufferingTimer?.cancel();
        if (!_isRetrying)
          _handleError('Stream playback failed. Please try again.');
        break;
      case BetterPlayerEventType.finished:
        _bufferingTimer?.cancel();
        _handleError('Stream ended.');
        break;
      case BetterPlayerEventType.initialized:
        if (containsError) {
          containsError = false;
          errorMessage = null;
          notifyListeners();
        }
        break;
      default:
        break;
    }
  }

  void _scheduleRetry() {
    _retryDebounce?.cancel();
    _retryDebounce = Timer(const Duration(milliseconds: 300), () {
      if (!_isDisposed && !_isRetrying && !containsError) retry();
    });
  }

  Future<void> retry() async {
    if (_isDisposed || _isRetrying || _currentUrl == null) return;
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
      c.removeEventsListener(_onPlayerEvent);
      c.pause();
      Future.delayed(const Duration(milliseconds: 300), () {
        try {
          c.dispose();
        } catch (_) {}
      });
    } catch (_) {}
  }

  Future<void> disposePlayer() async {
    if (_isDisposed) return;
    _isDisposed = true;
    await WakelockPlus.disable();
    try {
      await _pipChannel.invokeMethod('setPipEnabled', false);
    } catch (_) {}
    _pipTriggerTimer?.cancel();
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
