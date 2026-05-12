import 'package:flutter/widgets.dart';
import 'package:mero_tv/app/app.locator.dart';
import 'package:mero_tv/app/app.router.dart';
import 'package:mero_tv/models/channel_model.dart';
import 'package:mero_tv/models/logo_model.dart';
import 'package:mero_tv/models/stream_model.dart';
import 'package:mero_tv/repository/channel_repository.dart';
import 'package:mero_tv/ui/views/favorites/services/favorites_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final ChannelRepository _repository = locator<ChannelRepository>();
  final _navigationService = locator<NavigationService>();
  final FavoritesService _favoritesService = locator<FavoritesService>();
  final TextEditingController searchController = TextEditingController();

  HomeViewModel();

  bool isLoading = false;
  bool isSearching = false;
  String? errorMessage;
  String _searchQuery = '';

  List<ChannelModel> _matchedChannels = [];

  List<ChannelModel> get channelList {
    if (_searchQuery.isEmpty) return _matchedChannels;
    final q = _searchQuery.toLowerCase();
    return _matchedChannels
        .where((c) => c.name?.toLowerCase().contains(q) ?? false)
        .toList();
  }

  void onSearchChanged(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleSearch() {
    isSearching = !isSearching;
    if (!isSearching) {
      _searchQuery = '';
      searchController.clear();
    }
    notifyListeners();
  }

  // @override
  // void dispose() {
  //   searchController.dispose();
  //   super.dispose();
  // }

  Future<void> fetchChannelData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    // ── Fetch all three APIs ──────────────────────────────────────────────
    final channelResult = await _repository.getChannels();
    final logosResult = await _repository.getLogos();
    final streamsResult = await _repository.getStreams();

    // ── Unwrap channels (fatal) ───────────────────────────────────────────
    List<ChannelModel> channels = [];
    channelResult.fold(
      (failure) => errorMessage = failure.message,
      (data) => channels = data.where((c) => c.id != null).toList(),
    );

    if (errorMessage != null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    // ── Unwrap logos → Map<channelId, logoUrl> ────────────────────────────
    Map<String, String?> logoMap = {};
    logosResult.fold(
      (failure) => debugPrint('Logo fetch failed: ${failure.message}'),
      (logos) {
        for (final LogoModel logo in logos) {
          if (logo.channel != null && logo.url != null) {
            logoMap[logo.channel!] = logo.url;
          }
        }
      },
    );

    // ── Unwrap streams → Map<channelId, streamUrl> ────────────────────────
    Map<String, String?> streamMap = {};
    streamsResult.fold(
      (failure) => debugPrint('Stream fetch failed: ${failure.message}'),
      (streams) {
        for (final StreamModel stream in streams) {
          if (stream.channel != null && stream.url != null) {
            streamMap[stream.channel!] = stream.url;
          }
        }
      },
    );

    // ── Three-way join: channel.id == logo.channel == stream.channel ──────
    _matchedChannels = channels
        .where((c) => logoMap.containsKey(c.id) && streamMap.containsKey(c.id))
        .map((c) => c.copyWith(
              logoUrl: logoMap[c.id],
              streamUrl: streamMap[c.id],
            ))
        .toList();

    isLoading = false;
    notifyListeners();
  }

  Future<void> retry() => fetchChannelData();

  bool isFavorite(ChannelModel channel) =>
      _favoritesService.isFavorite(channel);

  Future<void> toggleFavorite(ChannelModel channel) async {
    await _favoritesService.toggleFavorite(channel);
    notifyListeners();
  }

  void navigateToPlayer(ChannelModel channel) {
    if (channel.streamUrl == null) return;
    _navigationService.navigateToVideoPlayerView(
      streamUrl: channel.streamUrl!,
      title: channel.name ?? '',
    );
  }
}
