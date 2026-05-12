// To parse this JSON data, do
//
//     final channelModel = channelModelFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'channel_model.g.dart';

List<ChannelModel> channelModelFromJson(String str) => List<ChannelModel>.from(
    json.decode(str).map((x) => ChannelModel.fromJson(x)));

String channelModelToJson(List<ChannelModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
@HiveType(typeId: 0)
class ChannelModel {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  List<String>? altNames;

  @HiveField(3)
  String? network;

  @HiveField(4)
  List<String>? owners;

  @HiveField(5)
  String? country;

  @HiveField(6)
  List<Category>? categories;

  @HiveField(7)
  bool? isNsfw;

  @HiveField(8)
  DateTime? launched;

  @HiveField(9)
  DateTime? closed;

  @HiveField(10)
  String? replacedBy;

  @HiveField(11)
  String? website;

  @HiveField(12)
  String? logoUrl;

  @HiveField(13)
  String? streamUrl;

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
    this.logoUrl,
    this.streamUrl
    
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) => _$ChannelModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelModelToJson(this);

  ChannelModel copyWith({
    String? id,
    String? name,
    List<String>? altNames,
    String? network,
    List<String>? owners,
    String? country,
    List<Category>? categories,
    bool? isNsfw,
    DateTime? launched,
    DateTime? closed,
    String? replacedBy,
    String? website,
    String? logoUrl,
    String? streamUrl
  }) {
    return ChannelModel(
      id: id ?? this.id,
      name: name ?? this.name,
      altNames: altNames ?? this.altNames,
      network: network ?? this.network,
      owners: owners ?? this.owners,
      country: country ?? this.country,
      categories: categories ?? this.categories,
      isNsfw: isNsfw ?? this.isNsfw,
      launched: launched ?? this.launched,
      closed: closed ?? this.closed,
      replacedBy: replacedBy ?? this.replacedBy,
      website: website ?? this.website,
      logoUrl: logoUrl ?? this.logoUrl,
      streamUrl: streamUrl ?? this.streamUrl
    );
  }
}


@HiveType(typeId: 1)
enum Category {
  @HiveField(0)
  animation,
  @HiveField(1)
  auto,
  @HiveField(2)
  business,
  @HiveField(3)
  classic,
  @HiveField(4)
  comedy,
  @HiveField(5)
  cooking,
  @HiveField(6)
  culture,
  @HiveField(7)
  documentary,
  @HiveField(8)
  education,
  @HiveField(9)
  entertainment,
  @HiveField(10)
  family,
  @HiveField(11)
  general,
  @HiveField(12)
  interactive,
  @HiveField(13)
  kids,
  @HiveField(14)
  legislative,
  @HiveField(15)
  lifestyle,
  @HiveField(16)
  movies,
  @HiveField(17)
  music,
  @HiveField(18)
  news,
  @HiveField(19)
  outdoor,
  @HiveField(20)
  public,
  @HiveField(21)
  relax,
  @HiveField(22)
  religious,
  @HiveField(23)
  science,
  @HiveField(24)
  series,
  @HiveField(25)
  shop,
  @HiveField(26)
  sports,
  @HiveField(27)
  travel,
  @HiveField(28)
  weather,
  @HiveField(29)
  xxx,
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
