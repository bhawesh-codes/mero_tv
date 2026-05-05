// lib/core/failures/failure_mapper.dart
import 'package:dio/dio.dart';
import 'package:mero_tv/core/exception/app_exception.dart';
import 'package:mero_tv/core/failures/failures.dart';

class FailureMapper {
  static Failure fromException(dynamic e) {
    // interceptor already converted DioException to AppException
    if (e is DioException && e.error is AppException) {
      final appException = e.error as AppException;

      if (appException is NetworkException) {
        return NetworkFailure(appException.message);
      }
      if (appException is ServerException) {
        return ServerFailure(appException.message);
      }
      if (appException is CancelException) {
        return NetworkFailure(appException.message);
      }
    }

    // fallback for non-Dio errors
    if (e is AppException) return ServerFailure(e.message);

    return const ServerFailure('Something went wrong.');
  }
}
