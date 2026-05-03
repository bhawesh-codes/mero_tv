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
    _channelList = await _repository.getStreams();
    print('channels loaded: ${_channelList?.length}');
  } catch (e) {
    _channelList = null;
    errorMessage = "Failed to load channel list: ${e.toString()}";
  }

  try {
    _logo = await _repository.getLogos();
    print('logos loaded: ${_logo?.length}');
    
    // Build the map after logos are loaded
    _logoUrlMap = {
      for (final logo in _logo ?? [])
        if (logo.channel != null) logo.channel!: logo.url
    };
  } catch (e) {
    _logo = null;
    errorMessage ??= "Failed to load logo: ${e.toString()}";
  }

  isLoading = false;
  notifyListeners();
}
}
