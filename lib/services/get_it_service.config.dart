// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../repository/channel_repository.dart' as _i1030;
import '../ui/views/favorites/services/favorites_service.dart' as _i166;
import 'api_service.dart' as _i738;
import 'dio_service/dio_module.dart' as _i642;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final dioModule = _$DioModule();
  gh.lazySingleton<_i361.Dio>(() => dioModule.dio);
  gh.lazySingleton<_i166.FavoritesService>(() => _i166.FavoritesService());
  gh.lazySingleton<_i738.ApiService>(() => _i738.ApiService(gh<_i361.Dio>()));
  gh.lazySingleton<_i1030.ChannelRepository>(
      () => _i1030.ChannelRepository(gh<_i738.ApiService>()));
  return getIt;
}

class _$DioModule extends _i642.DioModule {}
