// widgets/channel_list_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mero_tv/ui/common/app_colors.dart';
import 'package:mero_tv/ui/common/app_text.dart';
import 'package:mero_tv/ui/common/app_text_style.dart';
import 'package:mero_tv/ui/common/ui_helpers.dart';
import 'package:mero_tv/ui/views/home/widgets/channel_header.dart';
import 'package:mero_tv/ui/views/home/widgets/channel_card_widget.dart';
import 'package:stacked/stacked.dart';
import '../home_viewmodel.dart';
import 'carousel_slider_widget.dart';

class ChannelListWidget extends ViewModelWidget<HomeViewModel> {
  const ChannelListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.all(12.r),
      child: CustomScrollView(
        slivers: [
          // Carousel Slider
          const SliverToBoxAdapter(
            child: CarouselSliderWidget(),
          ),

          // Vertical Space
          const SliverToBoxAdapter(
            child: verticalSpaceSmall,
          ),
          const SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: CountryTag(countryName: 'Nepal')),
                horizontalSpaceMedium,
                Expanded(child: CountryTag(countryName: 'India')),
                horizontalSpaceMedium,
                Expanded(child: CountryTag(countryName: "Japan")),
              ],
            ),
          ),
          const SliverToBoxAdapter(
            child: verticalSpaceSmall,
          ),
          const SliverToBoxAdapter(
            child: Row(
              children: [
                Expanded(child: CountryTag(countryName: 'Australia')),
                horizontalSpaceMedium,
                Expanded(child: CountryTag(countryName: 'Canada')),
                horizontalSpaceMedium,
                Expanded(child: CountryTag(countryName: "US")),
              ],
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
                      style: bodyMedium.copyWith(color: kcDisabledTextColor)),
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

// country name → ISO code map (matching channel.country)
const _countryCodeMap = {
  'Nepal': 'NP',
  'India': 'IN',
  'Japan': 'JP',
  'Australia': 'AU',
  'Canada': 'CA',
  'US': 'US',
};

class CountryTag extends ViewModelWidget<HomeViewModel> {
  const CountryTag({
    super.key,
    required this.countryName,
  });

  final String countryName;

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    final code = _countryCodeMap[countryName];
    final isSelected = viewModel.selectedCountry == code;

    return GestureDetector(
      onTap: () => viewModel.onCountryChanged(code),
      child: Container(
        height: 30.h,
        width: 80.w,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? kcPrimaryColor : kcSecondaryTextColor,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isSelected ? kcPrimaryColor.withAlpha(15) : Colors.transparent,
        ),
        child: Center(
          child: Text(
            countryName,
            style: bodySmall.copyWith(
              color: isSelected ? kcPrimaryColor : kcPrimaryTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
