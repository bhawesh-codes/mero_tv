// models/country_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'country_model.g.dart';

@JsonSerializable()
class CountryModel {
  final String? code;
  final String? name;
  final String? flag;

  const CountryModel({this.code, this.name, this.flag});

  factory CountryModel.fromJson(Map<String, dynamic> json) =>
      _$CountryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CountryModelToJson(this);
}
