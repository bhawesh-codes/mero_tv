import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mero_tv/ui/common/app_colors.dart';
import 'package:mero_tv/ui/common/app_text_style.dart';
import 'package:mero_tv/ui/views/home/home_viewmodel.dart';
import 'package:stacked/stacked.dart';

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
        height: 70.h,
        width: 65.w,
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
                    color: kcPrimaryTextColor,
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
