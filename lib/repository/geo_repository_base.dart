// lib/repository/geo_repository_base.dart
import 'package:fpdart/fpdart.dart';
import 'package:mero_tv/core/failures/failures.dart';

abstract class GeoRepositoryBase {
  Future<Either<Failure, String>> getUserCountryCode();
}
