import 'package:mero_tv/models/channel_model.dart';
import 'package:mero_tv/models/logo_model.dart';
import 'package:mero_tv/repository/channel_repository_base.dart';
import 'package:mero_tv/services/api_service.dart';

class ChannelRepository implements ChannelRepositoryBase{
  final ApiService _apiService;
  ChannelRepository(this._apiService);
  @override
  Future<List<ChannelModel>> getChannels() async {
    try{ return await _apiService.getChannels();
    }catch(e){
      throw Exception(e.toString());
    }
    
  }

  @override
  Future<List<LogoModel>> getLogos()async {
    try{
      return await _apiService.getLogos();
    }catch(e){
      throw Exception(e.toString());
    }
  }
}