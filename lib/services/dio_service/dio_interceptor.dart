// lib/services/dio_interceptor.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mero_tv/core/exception/app_exception.dart';


class DioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('➡️ Request: ${options.method} ${options.uri}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
        '✅ Response: ${response.statusCode} ${response.requestOptions.uri}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('❌ Error: ${err.type} | ${err.message}');

    final appException = _mapToAppException(err);

    // reject with AppException so layers above never see DioException
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: appException,
        message: appException.message,
        type: err.type,
      ),
    );
  }

  AppException _mapToAppException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionError:
        return const NetworkException('No internet connection.');
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const NetworkException(
            'Connection timed out. Please try again.');
      case DioExceptionType.badResponse:
        return ServerException('Server error: ${err.response?.statusCode}');
      case DioExceptionType.cancel:
        return const CancelException('Request was cancelled.');
      default:
        return const ServerException('Something went wrong. Please try again.');
    }
  }
}
