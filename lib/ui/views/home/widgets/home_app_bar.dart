// widgets/home_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mero_tv/ui/common/app_colors.dart';
import 'package:mero_tv/ui/common/app_text_style.dart';
import '../home_viewmodel.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {

  const HomeAppBar({Key? key, required this.viewModel}) : super(key: key);
  final HomeViewModel viewModel;
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 5,
      backgroundColor: kcBackgroundColor,
      title: viewModel.isSearching ? _buildSearchField(viewModel) : _buildTitle(),
      actions: [
        if (!viewModel.isSearching)
          IconButton(
            onPressed: viewModel.toggleSearch,
            icon: const Icon(Icons.search, color: Colors.white),
          ),
      ],
    );
  }

  Widget _buildSearchField(HomeViewModel viewModel) {
    return SizedBox(
      height: 40.h,
      child: TextField(
        controller: viewModel.searchController,
        autofocus: true,
        onChanged: viewModel.onSearchChanged,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search channels..',
          hintStyle: const TextStyle(color: kcSecondaryTextColor),
          filled: true,
          fillColor: kcSurfaceColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
          prefixIcon: const Icon(Icons.search, color: kcSecondaryTextColor),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close, color: kcSecondaryTextColor),
            onPressed: () {
              viewModel.toggleSearch();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return RichText(
      text: TextSpan(children: [
        TextSpan(text: 'Mero ', style: titleLarge),
        TextSpan(
          text: 'TV',
          style: titleLarge.copyWith(color: kcPrimaryColor),
        ),
      ]),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
