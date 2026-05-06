import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mero_tv/ui/common/app_colors.dart';
import 'package:mero_tv/ui/common/app_text.dart';
import 'package:mero_tv/ui/common/app_text_style.dart';
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
                style: titleLarge.copyWith(color: kcPrimaryTextColor)),
            TextSpan(
                text: 'Favorites',
                style: titleLarge.copyWith(color: kcPrimaryColor))
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
                            child: channel.logoUrl != null
                                ? Image.network(
                                    channel.logoUrl!,
                                    width: 60.r,
                                    height: 60.r,
                                    fit: BoxFit.fill,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      width: 60.r,
                                      height: 60.r,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.tv,
                                          color: Colors.white),
                                    ),
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return Container(
                                        width: 60.r,
                                        height: 60.r,
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2),
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    width: 60.r,
                                    height: 60.r,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.tv,
                                        color: Colors.white),
                                  ),
                          ),
                          horizontalSpaceSmall,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppText(
                                  channel.title ?? channel.channel ?? 'Unknown',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: titleMedium.copyWith(
                                      color: kcPrimaryTextColor),
                                ),
                                AppText(
                                  "●LIVE",
                                  style:
                                      bodySmall.copyWith(color: kcPrimaryColor),
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
