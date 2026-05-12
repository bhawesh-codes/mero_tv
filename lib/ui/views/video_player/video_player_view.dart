import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:mero_tv/ui/common/app_colors.dart';
import 'package:mero_tv/ui/common/app_text.dart';
import 'package:mero_tv/ui/common/app_text_style.dart';
import 'package:mero_tv/ui/views/video_player/video_player_viewmodel.dart';
import 'package:stacked/stacked.dart';

class VideoPlayerView extends StackedView<VideoPlayerViewModel> {
  final String streamUrl;
  final String title;

  const VideoPlayerView({
    super.key,
    required this.streamUrl,
    required this.title,
  });

  @override
  Widget builder(
      BuildContext context, VideoPlayerViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: AppText(title,
            style: titleMedium.copyWith(color: kcPrimaryTextColor)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: viewModel.containsError
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.tv_off, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  AppText(
                    viewModel.errorMessage ?? 'Unable to load this channel.',
                    style: bodyMedium.copyWith(color: kcPrimaryTextColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Go Back',
                      style: TextStyle(color: kcPrimaryColor),
                    ),
                  ),
                ],
              )
            : Video(controller: viewModel.controller),
      ),
    );
  }

  @override
  VideoPlayerViewModel viewModelBuilder(BuildContext context) =>
      VideoPlayerViewModel();

  @override
  void onViewModelReady(VideoPlayerViewModel viewModel) =>
      viewModel.init(streamUrl);
}
