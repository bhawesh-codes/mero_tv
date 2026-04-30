import 'package:mero_tv/app/app.locator.dart';
import 'package:mero_tv/models/channel_model.dart';
import 'package:mero_tv/models/logo_model.dart';
import 'package:mero_tv/repository/channel_repository.dart';

import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  final ChannelRepository _repository = locator<ChannelRepository>();
  HomeViewModel();

  bool isLoading = false;
  String? errorMessage;
  List<ChannelModel>? _channelList;
  List<ChannelModel>? get channelList => _channelList;
  List<LogoModel>? _logo;
  List<LogoModel>? get logo => _logo;

  Future<void> fetchChannelData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      _channelList = await _repository.getChannels();
      // _logo = await _repository.getLogos();

      errorMessage = null;
    } catch (e) {
      _logo = null;
      _channelList = null;
      errorMessage = "Failed to load channel list ${e.toString()}";
    }
    isLoading = false;
    notifyListeners();
  }
}
