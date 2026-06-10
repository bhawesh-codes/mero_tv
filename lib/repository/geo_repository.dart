// lib/repository/geo_repository.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:mero_tv/core/failures/failures.dart';
import 'package:mero_tv/core/failures/failures_mapper.dart';
import 'package:mero_tv/repository/geo_repository_base.dart';
import 'package:mero_tv/services/geo_service.dart';

@lazySingleton
class GeoRepository implements GeoRepositoryBase {
  final GeoService _geoService;

  GeoRepository(this._geoService);

  @override
  Future<Either<Failure, String>> getUserCountryCode() async {
    try {
      final data = await _geoService.getGeoData();
      final code = data['cf-ipcountry'] as String?;
      if (code == null || code.isEmpty) {
        return left(const NoDataFailure('Country code not found.'));
      }
      return right(code.toUpperCase());
    } catch (e) {
      return left(FailureMapper.fromException(e));
    }
  }
}
