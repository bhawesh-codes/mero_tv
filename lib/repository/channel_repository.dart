// lib/repository/channel_repository.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:mero_tv/core/failures/failures.dart';
import 'package:mero_tv/core/failures/failures_mapper.dart';
import 'package:mero_tv/models/channel_model.dart';
import 'package:mero_tv/models/country_model.dart';
import 'package:mero_tv/models/logo_model.dart';
import 'package:mero_tv/models/stream_model.dart';
import 'package:mero_tv/repository/channel_repository_base.dart';
import 'package:mero_tv/services/api_service.dart';

@lazySingleton
class ChannelRepository implements ChannelRepositoryBase {
  final ApiService _apiService;

  ChannelRepository(this._apiService);

  @override
  Future<Either<Failure, List<StreamModel>>> getStreams() async {
    try {
      final result = await _apiService.getStreams();
      if (result.isEmpty) return left(const NoDataFailure('No streams found.'));
      return right(result);
    } catch (e) {
      return left(FailureMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<LogoModel>>> getLogos() async {
    try {
      final result = await _apiService.getLogos();
      return right(result);
    } catch (e) {
      return left(FailureMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<ChannelModel>>> getChannels() async {
    try {
      final result = await _apiService.getChannels();
      return right(result);
    } catch (e) {
      return left(FailureMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<CountryModel>>> getCountries() async {
    try {
      final result = await _apiService.getCountries();
      if (result.isEmpty) {
        return left(const NoDataFailure('No countries found.'));
      }
      return right(result);
    } catch (e) {
      return left(FailureMapper.fromException(e));
    }
  }
}
