import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mero_tv/app/app.locator.dart';
import 'package:mero_tv/app/app.router.dart';
import 'package:mero_tv/core/failures/failures.dart';
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
  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  List<ChannelModel> _matchedChannels = [];

  List<ChannelModel> get channelList {
    List<ChannelModel> filtered = _matchedChannels;

    if (_selectedCategory != 'All') {
      final category = Category.values.firstWhere(
        (e) =>
            e.name[0].toUpperCase() + e.name.substring(1) == _selectedCategory,
        orElse: () => Category.general,
      );
      filtered = filtered
          .where((c) => c.categories?.contains(category) ?? false)
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered = filtered
          .where((c) => c.name?.toLowerCase().contains(q) ?? false)
          .toList();
    }

    return filtered;
  }

  void onCategoryChanged(String value) {
    _selectedCategory = value;
    notifyListeners();
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

  Future<void> fetchChannelData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    // ── Fetch all three APIs concurrently ─────────────────────────────────
    final results = await Future.wait([
      _repository.getChannels(),
      _repository.getLogos(),
      _repository.getStreams(),
    ]);

    final channelResult = results[0] as Either<Failure, List<ChannelModel>>;
    final logosResult = results[1] as Either<Failure, List<LogoModel>>;
    final streamsResult = results[2] as Either<Failure, List<StreamModel>>;

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
