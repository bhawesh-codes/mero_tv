// lib/services/geo_service.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GeoService {
  final Dio _dio;

  GeoService(@Named('geoDio') this._dio);

  /// Returns raw response map from thuprai debug endpoint.
  Future<Map<String, dynamic>> getGeoData() async {
    final response = await _dio.get('api/debug');
    return response.data as Map<String, dynamic>;
  }
}
