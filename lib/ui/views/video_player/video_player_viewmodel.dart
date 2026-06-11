import 'dart:async';
import 'package:better_player_enhanced/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mero_tv/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class VideoPlayerViewModel extends BaseViewModel with WidgetsBindingObserver {
  final _navigationService = locator<NavigationService>();
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
  String? _currentUrl;
  Timer? _bufferingTimer;
  Timer? _retryDebounce;
  Timer? _pipTriggerTimer;

  bool get isPlayerReady =>
      _isPlayerReady && _controller != null && !containsError;
  bool get isInPip => _isInPip;

  Future<void> init(String url) async {
    _currentUrl = url;
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

  Future<dynamic> _handleNativeMethod(MethodCall call) async {
    if (call.method == 'onPipChanged') {
      final bool isInPip = call.arguments['isInPip'] as bool;
      _isInPip = isInPip;
      notifyListeners();
      debugPrint('📱 PiP state changed: isInPip=$isInPip');
    }
  }

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || _isDisposed) return;
    if (state == AppLifecycleState.resumed) {
      _isInPip = false;
      _controller!.play();
      notifyListeners();
    } else if (state == AppLifecycleState.paused && !_isInPip) {
      _controller!.pause();
    }
  }

  // ── Manual PiP trigger ─────────────────────────────────────────────────────
  Future<void> enablePip() async {
    if (_controller == null || _betterPlayerKey == null) {
      debugPrint('⚠️ PiP: controller or key is null');
      return;
    }
    try {
      debugPrint('📺 Enabling native PiP');
      await _pipChannel.invokeMethod('enterPip');
    } catch (e) {
      debugPrint('⚠️ Native PiP failed: $e');
    }
  }

  Future<void> _initializePlayer(String url) async {
    if (_isDisposed) return;

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
      notifyListeners();

      debugPrint('✅ Player initialized successfully for: $url');
    } catch (e, stackTrace) {
      debugPrint('❌ Player init error: $e');
      debugPrint('Stack trace: $stackTrace');

      if (!_isDisposed) {
        String userMessage = 'Unable to play this stream.';
        if (e
            .toString()
            .contains('minBufferMs cannot be less than bufferForPlaybackMs')) {
          userMessage = 'Player configuration error. Please update the app.';
        } else if (e.toString().contains('Network')) {
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

    debugPrint('📺 Player event: ${event.betterPlayerEventType}');

    if (event.betterPlayerEventType == BetterPlayerEventType.play ||
        event.betterPlayerEventType == BetterPlayerEventType.progress) {
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
        debugPrint('⏳ Buffering started');
        _bufferingTimer?.cancel();
        _bufferingTimer = Timer(const Duration(seconds: 10), () {
          if (_isDisposed || _isRetrying) return;
          debugPrint('⚠️ Buffering timeout — retrying');
          _scheduleRetry();
        });
        break;

      case BetterPlayerEventType.bufferingEnd:
        debugPrint('✅ Buffering ended');
        _bufferingTimer?.cancel();
        _retryDebounce?.cancel();
        break;

      case BetterPlayerEventType.exception:
        debugPrint('❌ Exception event received');
        _bufferingTimer?.cancel();
        if (!_isRetrying) {
          _handleError('Stream playback failed. Please try again.');
        }
        break;

      case BetterPlayerEventType.finished:
        debugPrint('🏁 Stream finished');
        _bufferingTimer?.cancel();
        _handleError('Stream ended.');
        break;

      case BetterPlayerEventType.initialized:
        debugPrint('🎯 Player initialized');
        if (containsError) {
          containsError = false;
          errorMessage = null;
          notifyListeners();
        }
        break;

      case BetterPlayerEventType.pause:
        debugPrint('⏸️ Player paused');
        break;

      case BetterPlayerEventType.setupDataSource:
        debugPrint('🔧 Setting up data source');
        break;

      default:
        debugPrint('📌 Unhandled event: ${event.betterPlayerEventType}');
        break;
    }
  }

  void _scheduleRetry() {
    _retryDebounce?.cancel();
    _retryDebounce = Timer(const Duration(milliseconds: 300), () {
      if (!_isDisposed && !_isRetrying && !containsError) {
        retry();
      }
    });
  }

  Future<void> retry() async {
    if (_isDisposed || _isRetrying || _currentUrl == null) return;
    _isRetrying = true;

    debugPrint('🔄 Retrying stream: $_currentUrl');

    _bufferingTimer?.cancel();
    _retryDebounce?.cancel();

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
    debugPrint('❌ Player error: $message');
    _bufferingTimer?.cancel();
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
    _pipTriggerTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _pipChannel.setMethodCallHandler(null);
    _bufferingTimer?.cancel();
    _retryDebounce?.cancel();
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
