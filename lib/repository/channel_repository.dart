import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:mero_tv/core/failures/failures.dart';
import 'package:mero_tv/core/failures/failures_mapper.dart';
import 'package:mero_tv/models/logo_model.dart';
import 'package:mero_tv/models/stream_model.dart';
import 'package:mero_tv/services/api_service.dart';

@lazySingleton
class ChannelRepository {
  final ApiService _apiService;
  ChannelRepository(this._apiService);

  Future<Either<Failure, List<StreamModel>>> getStreams() async {
    try {
      final result = await _apiService.getStreams();
      if (result.isEmpty) return left(const NoDataFailure('No streams found.'));
      return right(result);
    } catch (e) {
      return left(FailureMapper.fromException(e));
    }
  }

  Future<Either<Failure, List<LogoModel>>> getLogos() async {
    try {
      final result = await _apiService.getLogos();
      return right(result);
    } catch (e) {
      return left(FailureMapper.fromException(e));
    }
  }
}
