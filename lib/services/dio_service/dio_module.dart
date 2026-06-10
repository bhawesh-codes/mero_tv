// lib/services/dio_service/dio_module.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mero_tv/core/const/api_url.dart';
import 'package:mero_tv/services/dio_service/dio_interceptor.dart';

@module
abstract class DioModule {
  @lazySingleton
  Dio get dio {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiUrl.baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    dio.interceptors.add(DioInterceptor());
    return dio;
  }

  @lazySingleton
  @Named('geoDio')
  Dio get geoDio {
    return Dio(
      BaseOptions(
        baseUrl: ApiUrl.geoBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
  }
}
