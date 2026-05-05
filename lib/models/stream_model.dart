
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stream_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class StreamModel {
  @HiveField(0)
  String? channel;

  @HiveField(1)
  String? feed;

  @HiveField(2)
  String? title;

  @HiveField(3)
  String? url;

  @HiveField(4)
  String? quality;

  @HiveField(5)
  String? label;

  @HiveField(6)
  @JsonKey(name: 'user_agent')
  String? userAgent;

  @HiveField(7)
  String? referrer;

  StreamModel({
    this.channel,
    this.feed,
    this.title,
    this.url,
    this.quality,
    this.label,
    this.userAgent,
    this.referrer,
  });

  factory StreamModel.fromJson(Map<String, dynamic> json) =>
      _$StreamModelFromJson(json);
  Map<String, dynamic> toJson() => _$StreamModelToJson(this);
}
