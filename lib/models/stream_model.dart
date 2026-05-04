// To parse this JSON data, do
//
//     final streamModel = streamModelFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'stream_model.g.dart';

List<StreamModel> streamModelFromJson(String str) => List<StreamModel>.from(
    json.decode(str).map((x) => StreamModel.fromJson(x)));

String streamModelToJson(List<StreamModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class StreamModel {
  String? channel;
  String? feed;
  String? title;
  String? url;
  String? quality;
  String? label;
  String? userAgent;
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

  factory StreamModel.fromJson(Map<String, dynamic> json) => _$StreamModelFromJson(json);

  Map<String, dynamic> toJson() => _$StreamModelToJson(this);
}

