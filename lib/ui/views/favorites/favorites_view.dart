import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mero_tv/ui/common/app_colors.dart';
import 'package:mero_tv/ui/common/ui_helpers.dart';
import 'package:mero_tv/ui/views/favorites/favorites_viewmodel.dart';
import 'package:mero_tv/ui/views/video_player/video_player_view.dart';
import 'package:stacked/stacked.dart';

class FavoritesView extends StackedView<FavoritesViewModel> {
  const FavoritesView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context, FavoritesViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      appBar: AppBar(
        backgroundColor: kcBackgroundColor,
        title: RichText(
          text: TextSpan(children: [
            TextSpan(
                text: 'My ',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24.sp)),
            TextSpan(
                text: 'Favorites',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24.sp,
                    color: kcPrimaryColor))
          ]),
        ),
      ),
      body: SafeArea(
        // wrap with ValueListenableBuilder to reactively rebuild
        child: ValueListenableBuilder(
          valueListenable: viewModel.favoritesListenable,
          builder: (context, box, _) {
            final favorites = box.values.toList();
            if (favorites.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border,
                        size: 64.r, color: kcSecondaryTextColor),
                    verticalSpaceSmall,
                    const Text(
                      'No favorites yet',
                      style: TextStyle(color: kcPrimaryTextColor),
                    ),
                    verticalSpaceSmall,
                    const Text(
                      'Tap ♡ on any channel to add',
                      style: TextStyle(color: kcSecondaryTextColor),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.all(12.r),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final channel = favorites[index];
                return GestureDetector(
                  onTap: () {
                    if (channel.url != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VideoPlayerView(
                            streamUrl: channel.url!,
                            title: channel.title ?? 'Live TV',
                          ),
                        ),
                      );
                    }
                  },
                  child: SizedBox(
                    height: 70.h,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r)),
                      elevation: 4,
                      color: const Color.fromRGBO(19, 19, 19, 1),
                      child: Row(
                        children: [
                          horizontalSpaceSmall,
                          ClipOval(
                            child: Container(
                              width: 50.r,
                              height: 50.r,
                              color: Colors.grey[800],
                              child: const Icon(Icons.tv, color: Colors.white),
                            ),
                          ),
                          horizontalSpaceSmall,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  channel.title ?? channel.channel ?? 'Unknown',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: kcPrimaryTextColor),
                                ),
                                const Text(
                                  "●LIVE",
                                  style: TextStyle(color: kcPrimaryColor),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => viewModel.toggleFavorite(channel),
                            icon: const Icon(Icons.favorite,
                                color: kcPrimaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  FavoritesViewModel viewModelBuilder(BuildContext context) =>
      FavoritesViewModel();
}
