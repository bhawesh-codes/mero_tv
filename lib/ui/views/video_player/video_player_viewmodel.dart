import 'dart:async';
import 'package:better_player_enhanced/better_player.dart';
import 'package:flutter/material.dart';
import 'package:mero_tv/app/app.locator.dart';
import 'package:mero_tv/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class VideoPlayerViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  BetterPlayerController? _controller;
  BetterPlayerController? get controller => _controller;

  bool containsError = false;
  String? errorMessage;
  bool _isDisposed = false;
  bool _isPlayerReady = false;
  bool _isRetrying = false;
  String? _currentUrl;
  Timer? _bufferingTimer;
  Timer? _retryDebounce;

  bool get isPlayerReady =>
      _isPlayerReady && _controller != null && !containsError;

  Future<void> init(String url) async {
    _currentUrl = url;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_isDisposed) return;
      await _initializePlayer(url);
    });
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
          minBufferMs: 3000,
          maxBufferMs: 15000,
          bufferForPlaybackMs: 1500,
          bufferForPlaybackAfterRebufferMs: 3000,
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
          fit: BoxFit.cover,
          handleLifecycle: false,
          autoDispose: false, // we manage dispose manually
          allowedScreenSleep: false,
          fullScreenByDefault: false,
          useRootNavigator: true,
          placeholderOnTop: false,
          showPlaceholderUntilPlay: false,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            enableFullscreen: true,
            enableMute: true,
            enablePlayPause: true,
            enableProgressBar: false,
            enableSkips: false,
          ),
        ),
      );

      await controller.setupDataSource(dataSource);

      if (_isDisposed) {
        // view was closed while we were setting up — dispose silently
        _silentDispose(controller);
        return;
      }

      controller.addEventsListener(_onPlayerEvent);
      _controller = controller;
      _isPlayerReady = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Player init error: $e');
      if (!_isDisposed) {
        _handleError('Unable to play this stream.');
      }
    }
  }

  void _onPlayerEvent(BetterPlayerEvent event) {
    if (_isDisposed) return;

    switch (event.betterPlayerEventType) {
      case BetterPlayerEventType.bufferingStart:
        // Start a timer — if buffering lasts too long, retry
        _bufferingTimer?.cancel();
        _bufferingTimer = Timer(const Duration(seconds: 10), () {
          if (_isDisposed || _isRetrying) return;
          debugPrint('⚠️ Buffering timeout — retrying');
          _scheduleRetry();
        });
        break;

      case BetterPlayerEventType.bufferingEnd:
      case BetterPlayerEventType.play:
        _bufferingTimer?.cancel();
        _retryDebounce?.cancel();
        break;

      case BetterPlayerEventType.exception:
        _bufferingTimer?.cancel();
        if (!_isRetrying) {
          _handleError('Stream playback failed.');
        }
        break;

      case BetterPlayerEventType.finished:
        _bufferingTimer?.cancel();
        _handleError('Stream ended.');
        break;

      default:
        break;
    }
  }

  // Debounced retry — prevents rapid-fire retries
  void _scheduleRetry() {
    _retryDebounce?.cancel();
    _retryDebounce = Timer(const Duration(milliseconds: 300), () {
      if (!_isDisposed && !_isRetrying) {
        retry();
      }
    });
  }

  Future<void> retry() async {
    if (_isDisposed || _isRetrying) return;
    _isRetrying = true;

    _bufferingTimer?.cancel();
    _retryDebounce?.cancel();

    // Swap out the old controller safely
    final oldController = _controller;
    _controller = null;
    _isPlayerReady = false;
    containsError = false;
    errorMessage = null;
    notifyListeners();

    // Give ExoPlayer time to finish its internal cleanup before we dispose
    await Future.delayed(const Duration(milliseconds: 800));

    _silentDispose(oldController);

    // Another small gap before creating a new ExoPlayer instance
    await Future.delayed(const Duration(milliseconds: 400));

    _isRetrying = false;

    if (_isDisposed || _currentUrl == null) return;

    await _initializePlayer(_currentUrl!);
  }

  void _handleError(String message) {
    if (_isDisposed) return;
    _bufferingTimer?.cancel();
    containsError = true;
    errorMessage = message;
    _isPlayerReady = false;
    notifyListeners();
  }

  // Dispose a controller without touching any viewmodel state
  void _silentDispose(BetterPlayerController? c) {
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
    _bufferingTimer?.cancel();
    _retryDebounce?.cancel();
    final c = _controller;
    _controller = null;
    _isPlayerReady = false;
    _silentDispose(c);
  }

  void navigateToHome() {
    _navigationService.replaceWithHomeView();
  }

  @override
  void dispose() {
    disposePlayer();
    super.dispose();
  }
}
