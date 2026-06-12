// lib/services/channel_player_service.dart
import 'package:injectable/injectable.dart';
import 'package:mero_tv/models/channel_model.dart';

@lazySingleton
class ChannelPlayerService {
  List<ChannelModel> _channelList = [];
  int _currentIndex = 0;

  List<ChannelModel> get channelList => _channelList;
  int get currentIndex => _currentIndex;

  void setChannels(List<ChannelModel> channels, int index) {
    _channelList = channels;
    _currentIndex = index;
  }
}
