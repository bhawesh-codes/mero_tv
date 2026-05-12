import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:injectable/injectable.dart';
import 'package:mero_tv/models/channel_model.dart';

@LazySingleton()
class FavoritesService {
  Box<ChannelModel> get _box => Hive.box<ChannelModel>('favorites');

  // expose listenable for reactive UI
  ValueListenable<Box<ChannelModel>> get listenable => _box.listenable();

  List<ChannelModel> getFavorites() => _box.values.toList();

  bool isFavorite(ChannelModel channel) => _box.containsKey(channel.id);

  Future<void> toggleFavorite(ChannelModel channel) async {
    if (isFavorite(channel)) {
      await _box.delete(channel.id);
    } else {
      await _box.put(channel.id, channel);
    }
  }
}
