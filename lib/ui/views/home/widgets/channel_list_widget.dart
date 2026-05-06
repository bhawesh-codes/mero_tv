// widgets/channel_list_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mero_tv/ui/common/ui_helpers.dart';
import 'package:mero_tv/ui/views/home/widgets/caarousel_list_header.dart';
import 'package:mero_tv/ui/views/home/widgets/channel_card_widget.dart';
import '../home_viewmodel.dart';
import 'carousel_slider_widget.dart';

class ChannelListWidget extends StatelessWidget {
  final HomeViewModel viewModel;

  const ChannelListWidget({Key? key, required this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0.r),
      child: ListView.builder(
        itemCount: viewModel.channelList!.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSliderWidget(),
                verticalSpaceSmall,
                ChannelListHeader(),
                verticalSpaceSmall,
              ],
            );
          }

          final channel = viewModel.channelList![index];
          final url = viewModel.logoUrlMap[channel.channel];

          debugPrint('index $index | channel: ${channel.channel} | url: $url');

          return ChannelCard(
            channel: channel,
            logoUrl: url,
            isFavorite: viewModel.isFavorite(channel),
            onTap: () {
              final streamUrl = viewModel.channelList![index].url;
              final title = viewModel.channelList![index].title ?? 'Live TV';
              if (streamUrl != null) {
                viewModel.navigateToPlayer(streamUrl, title);
              }
            },
            onFavoriteToggle: () => viewModel.toggleFavorite(channel),
          );
        },
      ),
    );
  }
}
