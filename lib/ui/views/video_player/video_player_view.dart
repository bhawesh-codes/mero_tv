import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
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
  Widget builder(BuildContext context, VideoPlayerViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Video(controller: viewModel.controller),
      ),
    );
  }

  @override
  VideoPlayerViewModel viewModelBuilder(BuildContext context) => VideoPlayerViewModel();

  @override
  void onViewModelReady(VideoPlayerViewModel viewModel) => viewModel.init(streamUrl);
}