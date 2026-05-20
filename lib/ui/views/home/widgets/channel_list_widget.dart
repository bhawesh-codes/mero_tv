// widgets/channel_list_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mero_tv/models/channel_model.dart';
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
    const countryTags = [
      CountryTag(countryName: 'All'),
      CountryTag(countryName: 'Nepal'),
      CountryTag(countryName: 'India'),
      CountryTag(countryName: "Japan"),
      CountryTag(countryName: 'USA'),
      CountryTag(countryName: 'Australia'),
      CountryTag(countryName: "Canada"),
      CountryTag(countryName: "UK"),
      CountryTag(countryName: "South Korea"),
      CountryTag(countryName: "China"),
      CountryTag(countryName: "Pakistan"),
      CountryTag(countryName: "Germany"),
    ];
    const categoriesTags = [
      CategoryTag(
        categoryName: 'All',
        icon: Icons.category,
        iconColor: kcSoftAccentColor,
      ),
      CategoryTag(
        categoryName: 'News',
        icon: Icons.newspaper,
        iconColor: Colors.purpleAccent,
      ),
      CategoryTag(
        categoryName: 'Sports',
        icon: Icons.sports_soccer_outlined,
        iconColor: Colors.lightGreenAccent,
      ),
      CategoryTag(
        categoryName: "Movies",
        icon: Icons.movie_filter_outlined,
        iconColor: Colors.amberAccent,
      ),
      CategoryTag(
        categoryName: 'Kids',
        icon: Icons.child_care_outlined,
        iconColor: Colors.pinkAccent,
      ),
      CategoryTag(
        categoryName: 'Music',
        icon: Icons.music_note_rounded,
        iconColor: Colors.blueAccent,
      ),
      CategoryTag(
        categoryName: "Business",
        icon: Icons.business,
        iconColor: Colors.cyanAccent,
      ),
      CategoryTag(
        categoryName: "Entertainment",
        icon: Icons.movie_creation,
        iconColor: Colors.deepPurpleAccent,
      ),
      CategoryTag(
        categoryName: "Comedy",
        icon: Icons.theater_comedy_outlined,
        iconColor: Colors.deepOrangeAccent,
      ),
      CategoryTag(
        categoryName: "Cooking",
        icon: Icons.dinner_dining,
        iconColor: Colors.redAccent,
      ),
      CategoryTag(
        categoryName: "Family",
        icon: Icons.family_restroom,
        iconColor: Colors.indigoAccent,
      ),
      CategoryTag(
        categoryName: "Religous",
        icon: Icons.all_inclusive_rounded,
        iconColor: Colors.purpleAccent,
      ),
      CategoryTag(
        categoryName: "Documentary",
        icon: Icons.document_scanner,
        iconColor: Colors.lightGreenAccent,
      ),
      CategoryTag(
        categoryName: "Classic",
        icon: Icons.one_k_plus_outlined,
        iconColor: Colors.amberAccent,
      ),
      CategoryTag(
        categoryName: "Science",
        icon: Icons.science_outlined,
        iconColor: Colors.pinkAccent,
      ),
    ];
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
          //Categories
          SliverToBoxAdapter(
            child: Row(
              children: [
                Text(
                  'Categories',
                  style: bodyMedium.copyWith(color: kcPrimaryTextColor),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    viewModel.toggleCategoriesExpand();
                  },
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
          const SliverToBoxAdapter(
            child: verticalSpaceTiny,
          ),
          SliverToBoxAdapter(
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              clipBehavior: Clip.hardEdge,
              direction: Axis.horizontal,
              runSpacing: 4,
              spacing: 6,
              children: viewModel.showAllCategories
                  ? categoriesTags
                  : categoriesTags.take(5).toList(),
            ),
          ),
          const SliverToBoxAdapter(
            child: verticalSpaceTiny,
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
  'USA': 'US',
  'China': 'CN',
  'Pakistan': 'PK',
  'South Korea': 'KR',
  'UK': 'UK',
  'Germany': 'DE',
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
        width: 70.w,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? kcPrimaryColor : kcSecondaryTextColor,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isSelected
              ? kcSoftAccentColor.withAlpha(200)
              : kcDisabledTextColor,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                countryName,
                style: bodySmall.copyWith(color: kcPrimaryTextColor),
                maxLines: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryTag extends ViewModelWidget<HomeViewModel> {
  const CategoryTag(
      {super.key,
      required this.categoryName,
      required this.icon,
      required this.iconColor});

  final String categoryName;
  final IconData icon;
  final Color iconColor;
  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    // final category = viewModel.selectedCategory;
    final bool isSelected = viewModel.selectedCategory == categoryName;

    return GestureDetector(
      onTap: () => viewModel.onCategoryChanged(categoryName),
      child: Container(
        height: 58.h,
        width: 56.w,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? kcPrimaryColor : kcSecondaryTextColor,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? kcPrimaryColor.withAlpha(15) : Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: iconColor,
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  categoryName,
                  style: bodySmall.copyWith(
                    color: isSelected ? kcPrimaryColor : kcPrimaryTextColor,
                  ),
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
