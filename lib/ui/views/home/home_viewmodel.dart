// lib/ui/views/home/home_viewmodel.dart
import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mero_tv/app/app.locator.dart';
import 'package:mero_tv/app/app.router.dart';
import 'package:mero_tv/core/failures/failures.dart';
import 'package:mero_tv/models/channel_model.dart';
import 'package:mero_tv/models/country_model.dart';
import 'package:mero_tv/models/logo_model.dart';
import 'package:mero_tv/models/stream_model.dart';
import 'package:mero_tv/repository/channel_repository.dart';
import 'package:mero_tv/repository/geo_repository.dart';
import 'package:mero_tv/services/channel_player_service.dart';
import 'package:mero_tv/ui/views/favorites/services/favorites_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final ChannelRepository _repository = locator<ChannelRepository>();
  final GeoRepository _geoRepository = locator<GeoRepository>();
  final _navigationService = locator<NavigationService>();
  final FavoritesService _favoritesService = locator<FavoritesService>();
  final ChannelPlayerService _channelPlayerService =
      locator<ChannelPlayerService>();
  final TextEditingController searchController = TextEditingController();

  HomeViewModel();

  bool isLoading = false;
  bool isSearching = false;
  String? errorMessage;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  // ── Country dropdown state ────────────────────────────────────────────────

  /// null means "All" (no filter)
  String? _selectedCountry;
  String? get selectedCountry => _selectedCountry;

  List<CountryModel> _dropdownCountries = [];
  List<CountryModel> get dropdownCountries => _dropdownCountries;

  String? _userCountryCode;
  String? get userCountryCode => _userCountryCode;

  // ── Channel cache ─────────────────────────────────────────────────────────

  static bool _dataLoaded = false;
  static List<ChannelModel> _cachedChannels = [];
  List<ChannelModel> _matchedChannels = [];

  // ── Filtered channel list ─────────────────────────────────────────────────

  List<ChannelModel> get channelList {
    List<ChannelModel> filtered =
        _cachedChannels.isNotEmpty ? _cachedChannels : _matchedChannels;

    if (_selectedCountry != null) {
      filtered = filtered
          .where((c) => c.country?.toUpperCase() == _selectedCountry)
          .toList();
    }

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

  // ── Init ──────────────────────────────────────────────────────────────────

  Future<void> init() async {
    await Future.wait([
      fetchChannelData(),
      fetchCountries(),
    ]);
  }

  // ── Country methods ───────────────────────────────────────────────────────

  Future<void> fetchCountries() async {
    final results = await Future.wait([
      _geoRepository.getUserCountryCode(),
      _repository.getCountries(),
    ]);

    final geoResult = results[0] as Either<Failure, String>;
    final countriesResult = results[1] as Either<Failure, List<CountryModel>>;

    geoResult.fold(
      (failure) => debugPrint('Geo fetch failed: ${failure.message}'),
      (code) => _userCountryCode = code,
    );

    countriesResult.fold(
      (failure) => debugPrint('Countries fetch failed: ${failure.message}'),
      (countries) {
        final sorted = List<CountryModel>.from(countries)
          ..sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));

        if (_userCountryCode != null) {
          final userCountry = sorted
              .where((c) => c.code?.toUpperCase() == _userCountryCode)
              .toList();
          final rest = sorted
              .where((c) => c.code?.toUpperCase() != _userCountryCode)
              .toList();
          _dropdownCountries = [...userCountry, ...rest];
        } else {
          _dropdownCountries = sorted;
        }
      },
    );

    notifyListeners();
  }

  void onCountryChanged(String? countryCode) {
    _selectedCountry = countryCode;
    notifyListeners();
  }

  // ── Category / search ─────────────────────────────────────────────────────

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

  // ── Channel fetch ─────────────────────────────────────────────────────────

  Future<void> fetchChannelData() async {
    if (_dataLoaded && _cachedChannels.isNotEmpty) {
      _matchedChannels = _cachedChannels;
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final results = await Future.wait([
      _repository.getChannels(),
      _repository.getLogos(),
      _repository.getStreams(),
    ]);

    final channelResult = results[0] as Either<Failure, List<ChannelModel>>;
    final logosResult = results[1] as Either<Failure, List<LogoModel>>;
    final streamsResult = results[2] as Either<Failure, List<StreamModel>>;

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

    // Only the stream is essential — a channel is unplayable without it.
    // Logo is purely cosmetic (ChannelCard already shows a placeholder
    // icon when logoUrl is null), so don't drop channels just because
    // they lack a logo entry.
    _matchedChannels = channels
        .where((c) => streamMap.containsKey(c.id))
        .map((c) => c.copyWith(
              logoUrl: logoMap[c.id],
              streamUrl: streamMap[c.id],
            ))
        .toList();

    _cachedChannels = _matchedChannels;
    _dataLoaded = true;

    isLoading = false;
    notifyListeners();
  }

  Future<void> retry() => fetchChannelData();

  Future<void> refreshData() async {
    _dataLoaded = false;
    _cachedChannels = [];
    await fetchChannelData();
  }

  // ── Favorites ─────────────────────────────────────────────────────────────

  bool isFavorite(ChannelModel channel) =>
      _favoritesService.isFavorite(channel);

  Future<void> toggleFavorite(ChannelModel channel) async {
    await _favoritesService.toggleFavorite(channel);
    notifyListeners();
  }

  List<ChannelModel> get favoriteChannels =>
      _cachedChannels.where((c) => _favoritesService.isFavorite(c)).toList();

  // ── Navigation ────────────────────────────────────────────────────────────

  void navigateToPlayer(ChannelModel channel) {
    if (channel.streamUrl == null) return;

    // Pass the currently filtered list + index via shared service
    final list = channelList;
    final index = list.indexWhere((c) => c.id == channel.id);
    _channelPlayerService.setChannels(list, index < 0 ? 0 : index);

    _navigationService.navigateToVideoPlayerView(
      streamUrl: channel.streamUrl!,
      title: channel.name ?? '',
    );
  }

  // ── Categories expand ─────────────────────────────────────────────────────

  bool showAllCategories = false;

  void toggleCategoriesExpand() {
    showAllCategories = !showAllCategories;
    notifyListeners();
  }
}
