import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mero_tv/ui/common/app_colors.dart';
import 'package:mero_tv/ui/common/app_text_style.dart';
import 'package:mero_tv/ui/views/home/home_viewmodel.dart';
import 'package:stacked/stacked.dart';

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
