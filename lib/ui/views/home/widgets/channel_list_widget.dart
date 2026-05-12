// widgets/channel_list_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mero_tv/ui/common/ui_helpers.dart';
import 'package:mero_tv/ui/views/home/widgets/channel_header.dart';
import 'package:mero_tv/ui/views/home/widgets/channel_card_widget.dart';
import 'package:stacked/stacked.dart';
import '../home_viewmodel.dart';
import 'carousel_slider_widget.dart';

class ChannelListWidget extends StackedView<HomeViewModel> {
  const ChannelListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Padding(
      padding: EdgeInsets.all(12.0.r),
      child: ListView.builder(
        itemCount: viewModel.channelList.length,
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

          final channel = viewModel.channelList[index];
          final url = viewModel.channelList[index].logoUrl;

          debugPrint('index $index | channel: ${channel.name} | url: $url');

          return ChannelCard(
            channel: channel,
            logoUrl: url,
            isFavorite: viewModel.isFavorite(channel),
            onTap: () {
                viewModel.navigateToPlayer(channel);
              },
            
            onFavoriteToggle: () => viewModel.toggleFavorite(channel),
          );
        },
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) =>HomeViewModel()..fetchChannelData();
}
