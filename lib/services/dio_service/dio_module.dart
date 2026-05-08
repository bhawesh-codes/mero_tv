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
}
