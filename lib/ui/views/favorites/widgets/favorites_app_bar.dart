// widgets/favorites_app_bar.dart
import 'package:flutter/material.dart';
import '../../../common/app_colors.dart';
import '../../../common/app_text_style.dart';

class FavoritesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FavoritesAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kcBackgroundColor,
      title: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: 'My ',
            style: titleLarge.copyWith(color: kcPrimaryTextColor),
          ),
          TextSpan(
            text: 'Favorites',
            style: titleLarge.copyWith(color: kcPrimaryColor),
          ),
        ]),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
