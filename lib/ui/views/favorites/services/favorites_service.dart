import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:injectable/injectable.dart';
import 'package:mero_tv/models/stream_model.dart';

@LazySingleton()
class FavoritesService {
  Box<StreamModel> get _box => Hive.box<StreamModel>('favorites');

  // expose listenable for reactive UI
  ValueListenable<Box<StreamModel>> get listenable => _box.listenable();

  List<StreamModel> getFavorites() => _box.values.toList();

  bool isFavorite(StreamModel channel) => _box.containsKey(channel.channel);

  Future<void> toggleFavorite(StreamModel channel) async {
    if (isFavorite(channel)) {
      await _box.delete(channel.channel);
    } else {
      await _box.put(channel.channel, channel);
    }
  }
}
