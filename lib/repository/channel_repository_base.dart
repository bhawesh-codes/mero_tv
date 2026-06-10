// lib/repository/channel_repository_base.dart
import 'package:fpdart/fpdart.dart';
import 'package:mero_tv/core/failures/failures.dart';
import 'package:mero_tv/models/channel_model.dart';
import 'package:mero_tv/models/country_model.dart';
import 'package:mero_tv/models/logo_model.dart';
import 'package:mero_tv/models/stream_model.dart';

abstract class ChannelRepositoryBase {
  Future<Either<Failure, List<StreamModel>>> getStreams();
  Future<Either<Failure, List<LogoModel>>> getLogos();
  Future<Either<Failure, List<ChannelModel>>> getChannels();
  Future<Either<Failure, List<CountryModel>>> getCountries();
}
