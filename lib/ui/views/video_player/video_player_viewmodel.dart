import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:stacked/stacked.dart';

class VideoPlayerViewModel extends BaseViewModel {
  late final Player player;
  late final VideoController controller;

  void init(String url) {
    player = Player();
    controller = VideoController(player);
    player.open(Media(url));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
