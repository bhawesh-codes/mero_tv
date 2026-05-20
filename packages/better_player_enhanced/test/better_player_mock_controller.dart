import 'package:better_player_enhanced/better_player.dart';

class BetterPlayerMockController extends BetterPlayerController {
  BetterPlayerMockController(
    BetterPlayerConfiguration betterPlayerConfiguration, {
    BetterPlayerPlaylistConfiguration betterPlayerPlaylistConfiguration =
        const BetterPlayerPlaylistConfiguration(),
  }) : super(betterPlayerConfiguration,
            betterPlayerPlaylistConfiguration:
                betterPlayerPlaylistConfiguration);
}
