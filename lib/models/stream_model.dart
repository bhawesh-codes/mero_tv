import 'package:json_annotation/json_annotation.dart';

part 'stream_model.g.dart';

@JsonSerializable()
class StreamModel {
  
  String? channel;

  String? feed;

  String? title;

  String? url;

  String? quality;

  String? label;

  @JsonKey(name: 'user_agent')
  String? userAgent;

  String? referrer;

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
