// lib/ui/views/video_player/video_player_view.dart
import 'package:better_player_enhanced/better_player.dart';
import 'package:flutter/material.dart';
import 'package:mero_tv/ui/common/app_colors.dart';
import 'package:mero_tv/ui/views/video_player/video_player_viewmodel.dart';
import 'package:stacked/stacked.dart';

class VideoPlayerView extends StatefulWidget {
  final String streamUrl;
  final String title;

  const VideoPlayerView({
    super.key,
    required this.streamUrl,
    required this.title,
  });

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  final GlobalKey _betterPlayerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VideoPlayerViewModel>.reactive(
      viewModelBuilder: () => VideoPlayerViewModel(),
      onViewModelReady: (viewModel) {
        viewModel.setBetterPlayerKey(_betterPlayerKey);
        viewModel.init(widget.streamUrl);
      },
      disposeViewModel: true,
      builder: (context, viewModel, child) {
        // PiP Mode - Show minimal UI
        if (viewModel.isInPip) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: viewModel.isPlayerReady && viewModel.controller != null
                ? SizedBox.expand(
                    child: BetterPlayer(
                      key: _betterPlayerKey,
                      controller: viewModel.controller!,
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(color: kcPrimaryColor),
                  ),
          );
        }

        // Use PopScope instead of deprecated WillPopScope
        return PopScope(
          canPop: true,
          onPopInvoked: (didPop) async {
            if (didPop) return;
            viewModel.disposePlayer();
            if (context.mounted) Navigator.pop(context);
          },
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onVerticalDragEnd: (details) {
              if (details.primaryVelocity == null) return;
              if (details.primaryVelocity! < -300) {
                viewModel.switchToNext();
              } else if (details.primaryVelocity! > 300) {
                viewModel.switchToPrevious();
              }
            },
            child: Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.black,
                elevation: 0,
                title: Text(
                  viewModel.currentTitle.isNotEmpty
                      ? viewModel.currentTitle
                      : widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () async {
                    viewModel.disposePlayer();
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
                actions: [
                  // Favorite toggle for the currently playing channel
                  if (viewModel.currentChannel != null)
                    IconButton(
                      icon: Icon(
                        viewModel.isCurrentFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: viewModel.isCurrentFavorite
                            ? kcPrimaryColor
                            : Colors.white,
                      ),
                      tooltip: viewModel.isCurrentFavorite
                          ? 'Remove from favorites'
                          : 'Add to favorites',
                      onPressed: viewModel.toggleCurrentFavorite,
                    ),
                  if (viewModel.isPlayerReady)
                    IconButton(
                      icon: const Icon(
                        Icons.picture_in_picture_alt,
                        color: Colors.white,
                      ),
                      tooltip: 'Picture in Picture',
                      onPressed: viewModel.enablePip,
                    ),
                ],
              ),
              body: _buildBody(viewModel),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(VideoPlayerViewModel viewModel) {
    // Switching state
    if (viewModel.isSwitching) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: kcPrimaryColor),
            SizedBox(height: 20),
            Text(
              'Switching channel...',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      );
    }

    // Error state
    if (viewModel.containsError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 70),
              const SizedBox(height: 20),
              Text(
                viewModel.errorMessage ?? 'Unable to play this stream.',
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kcPrimaryColor,
                    ),
                    onPressed: () {
                      viewModel.retry();
                    },
                    child: const Text(
                      'Retry',
                      style: TextStyle(color: kcPrimaryTextColor),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    onPressed: viewModel.navigateBack,
                    child: const Text(
                      'Go Back',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    // Player ready
    if (viewModel.isPlayerReady && viewModel.controller != null) {
      return SizedBox.expand(
        child: BetterPlayer(
          key: _betterPlayerKey,
          controller: viewModel.controller!,
        ),
      );
    }

    // Loading state
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: kcPrimaryColor),
          SizedBox(height: 20),
          Text(
            'Loading stream...',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
