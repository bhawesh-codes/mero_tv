// widgets/favorites_body.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mero_tv/ui/views/favorites/widgets/empty_favorites_widgets.dart';
import 'package:stacked/stacked.dart';
import '../../video_player/video_player_view.dart';
import '../favorites_viewmodel.dart';
import 'favorite_card.dart';

class FavoritesBody extends StackedView<FavoritesViewModel> {

  const FavoritesBody({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, FavoritesViewModel viewModel, Widget? child) {
    return SafeArea(
      child: ValueListenableBuilder(
        valueListenable: viewModel.favoritesListenable,
        builder: (context, box, _) {
          final favorites = box.values.toList();

          if (favorites.isEmpty) {
            return const EmptyFavoritesWidget();
          }

          return Padding(
            padding: EdgeInsets.all(12.r),
            child: ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final channel = favorites[index];
                return FavoriteCard(
                  channel: channel,
                  onTap: () {
                    if (channel.streamUrl!= null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VideoPlayerView(
                            streamUrl: channel.streamUrl!,
                            title: channel.name ?? 'Live TV',
                          ),
                        ),
                      );
                    }
                  },
                  onFavoriteToggle: () => viewModel.toggleFavorite(channel),
                );
              },
            ),
          );
        },
      ),
    );
  }
  @override
  FavoritesViewModel viewModelBuilder(BuildContext context) =>
      FavoritesViewModel();
      
        
}
