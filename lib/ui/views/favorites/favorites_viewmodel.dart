import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:mero_tv/app/app.locator.dart';
import 'package:mero_tv/models/channel_model.dart';
import 'package:mero_tv/ui/views/favorites/services/favorites_service.dart';
import 'package:stacked/stacked.dart';

class FavoritesViewModel extends BaseViewModel {


  final FavoritesService _favoritesService = locator<FavoritesService>();

  // expose listenable to view
  ValueListenable<Box<ChannelModel>> get favoritesListenable =>
      _favoritesService.listenable;

  Future<void> toggleFavorite(ChannelModel channel) async {
    await _favoritesService.toggleFavorite(channel);
  }
}
