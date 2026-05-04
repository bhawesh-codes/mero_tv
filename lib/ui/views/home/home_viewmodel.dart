import 'package:mero_tv/app/app.locator.dart';
// import 'package:mero_tv/models/channel_model.dart';
import 'package:mero_tv/models/logo_model.dart';
import 'package:mero_tv/models/stream_model.dart';
import 'package:mero_tv/repository/channel_repository.dart';

import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  final ChannelRepository _repository = locator<ChannelRepository>();
  HomeViewModel();

  bool isLoading = false;
  bool isSearching = false;
  String? errorMessage;
  List<StreamModel>? _channelList;
  List<StreamModel>? get channelList => _channelList;
  List<LogoModel>? _logo;
  List<LogoModel>? get logo => _logo;

  // Add this
Map<String, String?> _logoUrlMap = {};
Map<String, String?> get logoUrlMap => _logoUrlMap;

Future<void> fetchChannelData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final allStreams = await _repository.getStreams();
      // only keep streams with non-null channel
      _channelList = allStreams.where((s) => s.channel != null).toList();
      print('streams with channel: ${_channelList?.length}');
    } catch (e) {
      _channelList = null;
      errorMessage = "Failed to load channel list: ${e.toString()}";
    }

    try {
      final allLogos = await _repository.getLogos();
      // build logo map: channel id -> url
      final logoMap = {
        for (final logo in allLogos)
          if (logo.channel != null) logo.channel!: logo.url
      };

      // for each stream, store its logo url if exists, else null
      _logoUrlMap = {
        for (final s in _channelList ?? [])
          s.channel!: logoMap[s.channel] // null if no matching logo
      };

      print('logo map built: ${_logoUrlMap.length}');
    } catch (e) {
      errorMessage ??= "Failed to load logo: ${e.toString()}";
    }

    isLoading = false;
    notifyListeners();
  }
  toggleSearch(){
    isSearching = !isSearching;
    notifyListeners();
  }
}
