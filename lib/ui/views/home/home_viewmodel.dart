import 'package:flutter/widgets.dart';
import 'package:mero_tv/app/app.locator.dart';
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
  String _searchQuery = '';

  List<StreamModel>? _channelList;
  Map<String, String?> _logoUrlMap = {};
  Map<String, String?> get logoUrlMap => _logoUrlMap;
  final TextEditingController searchController = TextEditingController();

  // filtered list based on search query
  List<StreamModel>? get channelList {
    if (_channelList == null) return null;
    if (_searchQuery.isEmpty) return _channelList;
    return _channelList!
        .where((s) =>
            s.title?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
            false)
        .toList();
  }

  void onSearchChanged(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleSearch() {
    isSearching = !isSearching;
    if (!isSearching) {
      // clear search when closing
      _searchQuery = '';
      searchController.clear();
    }
    notifyListeners();
  }
   @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchChannelData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final allStreams = await _repository.getStreams();
      _channelList = allStreams.where((s) => s.channel != null).toList();
    } catch (e) {
      _channelList = null;
      errorMessage = "Failed to load channel list: ${e.toString()}";
    }

    try {
      final List<LogoModel> allLogos = await _repository.getLogos();
      final logoMap = {
        for (final logo in allLogos)
          if (logo.channel != null) logo.channel!: logo.url
      };
      _logoUrlMap = {
        for (final s in _channelList ?? []) s.channel!: logoMap[s.channel]
      };
    } catch (e) {
      errorMessage ??= "Failed to load logo: ${e.toString()}";
    }

    isLoading = false;
    notifyListeners();
  }
}
