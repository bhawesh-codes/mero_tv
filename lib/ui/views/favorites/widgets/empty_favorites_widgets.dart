// widgets/empty_favorites_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/app_colors.dart';
import '../../../common/app_text.dart';
import '../../../common/app_text_style.dart';
import '../../../common/ui_helpers.dart';

class EmptyFavoritesWidget extends StatelessWidget {
  const EmptyFavoritesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 64.r, color: kcSecondaryTextColor),
          verticalSpaceSmall,
          AppText(
            'No favorites yet',
            style: bodyMedium.copyWith(color: kcPrimaryTextColor),
          ),
          verticalSpaceSmall,
          AppText(
            'Tap ♡ on any channel to add',
            style: bodyMedium.copyWith(color: kcSecondaryTextColor),
          ),
        ],
      ),
    );
  }
}
