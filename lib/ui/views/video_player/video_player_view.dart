import 'package:better_player_enhanced/better_player.dart';
import 'package:flutter/material.dart';
import 'package:mero_tv/ui/common/app_colors.dart';
import 'package:mero_tv/ui/views/video_player/video_player_viewmodel.dart';
import 'package:stacked/stacked.dart';

class VideoPlayerView extends StatelessWidget {
  final String streamUrl;
  final String title;

  const VideoPlayerView({
    super.key,
    required this.streamUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VideoPlayerViewModel>.reactive(
      viewModelBuilder: () => VideoPlayerViewModel(),
      onViewModelReady: (viewModel) {
        viewModel.init(streamUrl);
      },
      disposeViewModel: true,
      builder: (context, viewModel, child) {
        return WillPopScope(
          onWillPop: () async {
            await viewModel.disposePlayer();
            return true;
          },
          child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              elevation: 0,
              title: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () async {
                  await viewModel.disposePlayer();

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            body: _buildBody(viewModel),
          ),
        );
      },
    );
  }

  Widget _buildBody(VideoPlayerViewModel viewModel) {
    if (viewModel.containsError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 70,
              ),
              const SizedBox(height: 20),
              Text(
                viewModel.errorMessage ?? 'Unable to play this stream.',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kcPrimaryColor,
                ),
                onPressed: viewModel.navigateBack,
                child: const Text(
                  'Go Back',
                  style: TextStyle(color: kcPrimaryTextColor),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (viewModel.isPlayerReady && viewModel.controller != null) {
      return SizedBox.expand(
        child: BetterPlayer(
          controller: viewModel.controller!,
        ),
      );
    }

    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: kcPrimaryColor,
          ),
          SizedBox(height: 20),
          Text(
            'Loading stream...',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
