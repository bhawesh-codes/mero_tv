import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:injectable/injectable.dart';
import 'package:mero_tv/models/channel_model.dart';

@LazySingleton()
class FavoritesService {
  Box<ChannelModel>? _box;

  // Lazy initialization with caching
  Box<ChannelModel> get _boxInstance {
    _box ??= Hive.box<ChannelModel>('favorites');
    return _box!;
  }

  // expose listenable for reactive UI
  ValueListenable<Box<ChannelModel>> get listenable =>
      _boxInstance.listenable();

  List<ChannelModel> getFavorites() => _boxInstance.values.toList();

  bool isFavorite(ChannelModel channel) => _boxInstance.containsKey(channel.id);

  Future<void> toggleFavorite(ChannelModel channel) async {
    if (isFavorite(channel)) {
      await _boxInstance.delete(channel.id);
    } else {
      await _boxInstance.put(channel.id, channel);
    }
  }
}
