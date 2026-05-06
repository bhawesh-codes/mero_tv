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

  @HiveField(8)
  String? logoUrl;

  StreamModel({
    this.channel,
    this.feed,
    this.title,
    this.url,
    this.quality,
    this.label,
    this.userAgent,
    this.referrer,
    this.logoUrl,
  });

  factory StreamModel.fromJson(Map<String, dynamic> json) =>
      _$StreamModelFromJson(json);
  Map<String, dynamic> toJson() => _$StreamModelToJson(this);

  // CopyWith method
  StreamModel copyWith({
    String? channel,
    String? feed,
    String? title,
    String? url,
    String? quality,
    String? label,
    String? userAgent,
    String? referrer,
    String? logoUrl,
  }) {
    return StreamModel(
      channel: channel ?? this.channel,
      feed: feed ?? this.feed,
      title: title ?? this.title,
      url: url ?? this.url,
      quality: quality ?? this.quality,
      label: label ?? this.label,
      userAgent: userAgent ?? this.userAgent,
      referrer: referrer ?? this.referrer,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }
}
