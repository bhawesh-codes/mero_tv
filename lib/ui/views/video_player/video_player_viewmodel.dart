import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:stacked/stacked.dart';

class VideoPlayerViewModel extends BaseViewModel {
  late final Player player;
  late final VideoController controller;
  Timer? _timeoutTimer;
  bool containsError = false;
  String? errorMessage;

  void init(String url) {
    player = Player();
    controller = VideoController(player);
    player.open(Media(url));

    // cancel timer only when video actually starts rendering
    player.stream.buffering.listen((isBuffering) {
      debugPrint('Buffering: $isBuffering');
      if (!isBuffering && player.state.playing) {
        // video is actually playing and not buffering
        _timeoutTimer?.cancel();
      }
    });
    // print('Timer started!');
    _timeoutTimer = Timer(const Duration(seconds: 60), _onTimeout);
    
  }

  void _onTimeout() {
    // debugPrint('Timer fired!');
    containsError = true;
    errorMessage = 'Unable to load this channel. Please try another.';
    notifyListeners();
  }

  

  @override
  void dispose() {
    debugPrint('VideoPlayerViewModel disposed!');
    _timeoutTimer?.cancel();
    player.dispose();
    super.dispose();
  }
}
