import 'package:flutter/widgets.dart';
import 'package:mero_tv/app/app.locator.dart';
import 'package:mero_tv/app/app.router.dart';
import 'package:mero_tv/models/stream_model.dart';
import 'package:mero_tv/repository/channel_repository.dart';
import 'package:mero_tv/ui/views/favorites/services/favorites_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final ChannelRepository _repository = locator<ChannelRepository>();
  HomeViewModel();
  final _navigationService = locator<NavigationService>();

  bool isLoading = false;
  bool isSearching = false;
  String? errorMessage;
  String _searchQuery = '';

  List<StreamModel>? _channelList;
  Map<String, String?> _logoUrlMap = {};
  Map<String, String?> get logoUrlMap => _logoUrlMap;
  final TextEditingController searchController = TextEditingController();
  final FavoritesService _favoritesService = locator<FavoritesService>();

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

    // getStreams returns Either<Failure, List<StreamModel>>
    final streamsResult = await _repository.getStreams();

    streamsResult.fold(
      (failure) {
        // Left — failure
        _channelList = null;
        errorMessage = failure.message;
      },
      (streams) {
        // Right — success
        _channelList = streams.where((s) => s.channel != null).toList();
      },
    );

    // only load logos if streams succeeded
    if (_channelList != null) {
      final logosResult = await _repository.getLogos();

      logosResult.fold(
        (failure) {
          // logos failing is non-fatal — just log it
          debugPrint('Logo failure: ${failure.message}');
          _logoUrlMap = {};
        },
        (logos) {
          final logoMap = {
            for (final logo in logos)
              if (logo.channel != null) logo.channel!: logo.url
          };
          _logoUrlMap = {
            for (final s in _channelList ?? []) s.channel!: logoMap[s.channel]
          };
           _channelList = _channelList?.map((stream) {
            final logoUrl = logoMap[stream.channel];
            return stream.copyWith(logoUrl: logoUrl);
          }).toList();
        },
      );
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> retry() => fetchChannelData();

  bool isFavorite(StreamModel channel) => _favoritesService.isFavorite(channel);

  Future<void> toggleFavorite(StreamModel channel) async {
    await _favoritesService.toggleFavorite(channel);
    notifyListeners();
  }
  navigateToPlayer(String streamUrl, String title){
    _navigationService.navigateToVideoPlayerView(streamUrl: streamUrl, title: title);
  }

}
