// widgets/channel_list_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mero_tv/ui/common/app_colors.dart';
import 'package:mero_tv/ui/common/app_text.dart';
import 'package:mero_tv/ui/common/app_text_style.dart';
import 'package:mero_tv/ui/common/ui_helpers.dart';
import 'package:mero_tv/ui/views/home/widgets/category_tag.dart';
import 'package:mero_tv/ui/views/home/widgets/channel_dropdown_widget.dart';
import 'package:mero_tv/ui/views/home/widgets/channel_card_widget.dart';
import 'package:stacked/stacked.dart';
import '../home_viewmodel.dart';

class ChannelListWidget extends ViewModelWidget<HomeViewModel> {
  const ChannelListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 4.h),
      child: CustomScrollView(
        slivers: [
          // ── Country dropdown row ──────────────────────────────────────────
          const SliverToBoxAdapter(
            child: Align(
              alignment: Alignment.centerLeft,
              child: CountryDropdownWidget(),
            ),
          ),

          const SliverToBoxAdapter(child: verticalSpaceMedium),

          // ── Categories ────────────────────────────────────────────────
          const SliverToBoxAdapter(child: verticalSpaceTiny),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 70.h,
              width: 65.w,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categoriesTags.length,
                separatorBuilder: (context, index) => SizedBox(width: 8.w),
                itemBuilder: (context, index) => categoriesTags[index],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: verticalSpaceMedium),

          // ── Channel header ────────────────────────────────────────────────
          // SliverToBoxAdapter(
          //   child: ChannelListHeader(viewModel: viewModel),
          // ),

          // ── Channel list ──────────────────────────────────────────────────
          viewModel.channelList.isEmpty
              ? SliverToBoxAdapter(
                  child: Center(
                    child: AppText(
                      'No data',
                      style: bodyMedium.copyWith(color: kcSecondaryTextColor),
                    ),
                  ),
                )
              : SliverList.builder(
                  itemCount: viewModel.channelList.length,
                  itemBuilder: (context, index) {
                    final channel = viewModel.channelList[index];
                    return ChannelCard(
                      channel: channel,
                      logoUrl: channel.logoUrl,
                      isFavorite: viewModel.isFavorite(channel),
                      onTap: () => viewModel.navigateToPlayer(channel),
                      onFavoriteToggle: () => viewModel.toggleFavorite(channel),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
