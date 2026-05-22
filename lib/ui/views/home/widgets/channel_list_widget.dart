// widgets/channel_list_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mero_tv/ui/common/app_colors.dart';
import 'package:mero_tv/ui/common/app_text.dart';
import 'package:mero_tv/ui/common/app_text_style.dart';
import 'package:mero_tv/ui/common/ui_helpers.dart';
import 'package:mero_tv/ui/views/home/widgets/category_tag.dart';
import 'package:mero_tv/ui/views/home/widgets/channel_header.dart';
import 'package:mero_tv/ui/views/home/widgets/channel_card_widget.dart';
import 'package:mero_tv/ui/views/home/widgets/country_tag.dart';
import 'package:stacked/stacked.dart';
import '../home_viewmodel.dart';

class ChannelListWidget extends ViewModelWidget<HomeViewModel> {
  const ChannelListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.r, 4.r, 12.r, 4.r),
      child: CustomScrollView(
        slivers: [
          // Carousel Slider
          // const SliverToBoxAdapter(
          //   child: CarouselSliderWidget(),
          // ),

          SliverToBoxAdapter(
            child: Row(
              children: [
                Text(
                  'Countries',
                  style: bodyMedium.copyWith(color: kcPrimaryTextColor),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: viewModel.toggleCountriesExpand,
                  label: Text(
                    'View All',
                    style: bodySmall,
                  ),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  iconAlignment: IconAlignment.end,
                  style: TextButton.styleFrom(
                      foregroundColor: kcPrimaryColor,
                      padding: const EdgeInsets.all(0)),
                )
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              clipBehavior: Clip.hardEdge,
              direction: Axis.horizontal,
              runSpacing: 4,
              spacing: 6,
              children: viewModel.showAllCountries
                  ? countryTags
                  : countryTags.take(4).toList(),
            ),
          ),
          // const SliverToBoxAdapter(
          //   child: verticalSpaceSmall,
          // ),
          // const SliverToBoxAdapter(
          //   child: Row(
          //     children: [
          //       Expanded(child: CountryTag(countryName: 'Australia')),
          //       horizontalSpaceMedium,
          //       Expanded(child: CountryTag(countryName: 'Canada')),
          //       horizontalSpaceMedium,
          //       Expanded(child: CountryTag(countryName: "US")),
          //     ],
          //   ),
          // ),
          const SliverToBoxAdapter(
            child: verticalSpaceTiny,
          ),
          // Categories
          SliverToBoxAdapter(
            child: Row(
              children: [
                Text(
                  'Categories',
                  style: bodyMedium.copyWith(color: kcPrimaryTextColor),
                ),
              ],
            ),
          ),
          const SliverToBoxAdapter(
            child: verticalSpaceTiny,
          ),
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

          const SliverToBoxAdapter(
            child: verticalSpaceSmall,
          ),
          // Channel Header
          SliverToBoxAdapter(
            child: ChannelListHeader(viewModel: viewModel),
          ),

          // Vertical Space
          const SliverToBoxAdapter(
            child: verticalSpaceSmall,
          ),

          viewModel.channelList.isEmpty
              ? SliverToBoxAdapter(
                  child: Center(
                  child: AppText("No data",
                      style: bodyMedium.copyWith(color: kcSecondaryTextColor)),
                ))
              : // Channel List - Using SliverList.builder for 15,000 items
              SliverList.builder(
                  itemCount: viewModel.channelList.length,
                  itemBuilder: (context, index) {
                    final channel = viewModel.channelList[index];
                    final url = channel.logoUrl;

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
        ],
      ),
    );
  }
}
