import 'package:dio/dio.dart';
import 'package:mero_tv/models/channel_model.dart';
import 'package:mero_tv/models/logo_model.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

@GET('channels.json')
Future<List<ChannelModel>> getChannels();

@GET('logos.json')
Future<List<LogoModel>> getLogos();
}