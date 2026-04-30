// To parse this JSON data, do
//
//     final logoModel = logoModelFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
part 'logo_model.g.dart';

List<LogoModel> logoModelFromJson(String str) =>
    List<LogoModel>.from(json.decode(str).map((x) => LogoModel.fromJson(x)));

String logoModelToJson(List<LogoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class LogoModel {
  String? channel;
  String? feed;
  List<String>? tags;
  int? width;
  int? height;
  Format? format;
  String? url;

  LogoModel({
    this.channel,
    this.feed,
    this.tags,
    this.width,
    this.height,
    this.format,
    this.url,
  });

  factory LogoModel.fromJson(Map<String, dynamic> json) => LogoModel(
        channel: json["channel"],
        feed: json["feed"],
        tags: json["tags"] == null
            ? []
            : List<String>.from(json["tags"]!.map((x) => x)),
        width: json["width"],
        height: json["height"],
        format: formatValues.map[json["format"]]!,
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "channel": channel,
        "feed": feed,
        "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
        "width": width,
        "height": height,
        "format": formatValues.reverse[format],
        "url": url,
      };
}

enum Format { gif, jpeg, png, svg, webP }

final formatValues = EnumValues({
  "GIF": Format.gif,
  "JPEG": Format.jpeg,
  "PNG": Format.png,
  "SVG": Format.svg,
  "WebP": Format.webP
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
