// lib/services/api_service.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mero_tv/models/channel_model.dart';
import 'package:mero_tv/models/country_model.dart';
import 'package:mero_tv/models/logo_model.dart';
import 'package:mero_tv/models/stream_model.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@lazySingleton
@RestApi()
abstract class ApiService {
  @factoryMethod
  factory ApiService(Dio dio) = _ApiService;

  @GET('channels.json')
  Future<List<ChannelModel>> getChannels();

  @GET('logos.json')
  Future<List<LogoModel>> getLogos();

  @GET('streams.json')
  Future<List<StreamModel>> getStreams();

  @GET('countries.json')
  Future<List<CountryModel>> getCountries();
}
