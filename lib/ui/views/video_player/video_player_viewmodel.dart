import 'dart:async';
import 'package:better_player_enhanced/better_player.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class VideoPlayerViewModel extends BaseViewModel {
  BetterPlayerController? controller;
  Timer? _timeoutTimer;
  bool containsError = false;
  String? errorMessage;
  bool _isDisposed = false;
  bool _errorHandled = false; // ✅ prevents multiple exception firings

  double _volume = 1.0;
  double get volume => _volume;
  bool _isMuted = false;
  bool get isMuted => _isMuted;

  void init(String url) {
    debugPrint('▶️ Attempting to stream: $url');

    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      url,
      liveStream: true,
      bufferingConfiguration: const BetterPlayerBufferingConfiguration(
        minBufferMs: 2000,
        maxBufferMs: 10000,
        bufferForPlaybackMs: 1000,
        bufferForPlaybackAfterRebufferMs: 2000,
      ),
      headers: {
        'User-Agent': 'Mozilla/5.0',
      },
      notificationConfiguration: const BetterPlayerNotificationConfiguration(
        showNotification: false, // ✅ avoids notification channel errors
      ),
    );

    controller = BetterPlayerController(
      const BetterPlayerConfiguration(
        autoPlay: true,
        looping: false, // ✅ don't loop dead streams
        aspectRatio: 16 / 9,
        fit: BoxFit.contain,
        handleLifecycle: true,
        autoDispose: true,
        allowedScreenSleep: false,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          showControls: true,
          enableAudioTracks: true,
          enableFullscreen: true,
          enableMute: true,
          enablePlayPause: true,
          enableProgressBar: false, // ✅ off for live streams
        ),
      ),
      betterPlayerDataSource: dataSource,
    );

    controller!.addEventsListener(_onPlayerEvent);

    // ✅ shorter timeout — 404s fail fast, no need to wait 60s
    _timeoutTimer = Timer(const Duration(seconds: 30), _onTimeout);
  }

  void _onPlayerEvent(BetterPlayerEvent event) {
    if (_isDisposed || _errorHandled) return; // ✅ ignore events after error

    debugPrint('▶️ Player event: ${event.betterPlayerEventType}');

    switch (event.betterPlayerEventType) {
      case BetterPlayerEventType.initialized:
      case BetterPlayerEventType.play:
      case BetterPlayerEventType.bufferingEnd:
        _timeoutTimer?.cancel(); // ✅ stream is alive, cancel timeout
        break;

      case BetterPlayerEventType.exception:
        _errorHandled = true; // ✅ block further exception events
        _timeoutTimer?.cancel();
        // ✅ small delay so ExoPlayer finishes cleanup before we rebuild UI
        Future.delayed(const Duration(milliseconds: 300), _onTimeout);
        break;

      default:
        break;
    }
  }

  void _onTimeout() {
    if (_isDisposed) return;
    if (containsError) return;

    // ✅ stop and release the player immediately to prevent freeze
    _safeDisposeController();

    containsError = true;
    errorMessage = 'Unable to load this channel. Please try another.';
    notifyListeners();
  }

  void _safeDisposeController() {
    try {
      controller?.removeEventsListener(_onPlayerEvent);
      controller?.pause();
      controller?.dispose();
      controller = null;
    } catch (e) {
      debugPrint('Controller dispose error (safe): $e');
    }
  }

  @override
  void dispose() {
    debugPrint('VideoPlayerViewModel disposed!');
    _isDisposed = true;
    _timeoutTimer?.cancel();
    _safeDisposeController();
    super.dispose();
  }
}
