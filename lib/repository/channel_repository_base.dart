import 'package:mero_tv/models/channel_model.dart';
import 'package:mero_tv/models/logo_model.dart';

abstract class ChannelRepositoryBase {
  Future<List<ChannelModel>> getChannels();
  Future<List<LogoModel>> getLogos();
}