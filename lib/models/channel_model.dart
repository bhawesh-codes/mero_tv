// To parse this JSON data, do
//
//     final channelModel = channelModelFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
part 'channel_model.g.dart';

List<ChannelModel> channelModelFromJson(String str) => List<ChannelModel>.from(
    json.decode(str).map((x) => ChannelModel.fromJson(x)));

String channelModelToJson(List<ChannelModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class ChannelModel {
  String? id;
  String? name;
  List<String>? altNames;
  String? network;
  List<String>? owners;
  String? country;
  List<Category>? categories;
  bool? isNsfw;
  DateTime? launched;
  DateTime? closed;
  String? replacedBy;
  String? website;

  ChannelModel({
    this.id,
    this.name,
    this.altNames,
    this.network,
    this.owners,
    this.country,
    this.categories,
    this.isNsfw,
    this.launched,
    this.closed,
    this.replacedBy,
    this.website,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) => _$ChannelModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelModelToJson(this);
}

enum Category {
  animation,
  auto,
  business,
  classic,
  comedy,
  cooking,
  culture,
  documentary,
  education,
  entertainment,
  family,
  general,
  interactive,
  kids,
  legislative,
  lifestyle,
  movies,
  music,
  news,
  outdoor,
  public,
  relax,
  religious,
  science,
  series,
  shop,
  sports,
  travel,
  weather,
  xxx
}

final categoryValues = EnumValues({
  "animation": Category.animation,
  "auto": Category.auto,
  "business": Category.business,
  "classic": Category.classic,
  "comedy": Category.comedy,
  "cooking": Category.cooking,
  "culture": Category.culture,
  "documentary": Category.documentary,
  "education": Category.education,
  "entertainment": Category.entertainment,
  "family": Category.family,
  "general": Category.general,
  "interactive": Category.interactive,
  "kids": Category.kids,
  "legislative": Category.legislative,
  "lifestyle": Category.lifestyle,
  "movies": Category.movies,
  "music": Category.music,
  "news": Category.news,
  "outdoor": Category.outdoor,
  "public": Category.public,
  "relax": Category.relax,
  "religious": Category.religious,
  "science": Category.science,
  "series": Category.series,
  "shop": Category.shop,
  "sports": Category.sports,
  "travel": Category.travel,
  "weather": Category.weather,
  "xxx": Category.xxx,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
