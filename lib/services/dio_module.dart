import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mero_tv/app/const/api_url.dart';
import 'package:mero_tv/services/dio_interceptor.dart';

@module
abstract class DioModule {
  @lazySingleton
  Dio get dio {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiUrl.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    dio.interceptors.add(DioInterceptor());
    return dio;
  }
}
