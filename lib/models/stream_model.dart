// To parse this JSON data, do
//
//     final streamModel = streamModelFromJson(jsonString);

import 'dart:convert';

List<StreamModel> streamModelFromJson(String str) => List<StreamModel>.from(
    json.decode(str).map((x) => StreamModel.fromJson(x)));

String streamModelToJson(List<StreamModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StreamModel {
  String? channel;
  String? feed;
  String? title;
  String? url;
  Quality? quality;
  Label? label;
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

  factory StreamModel.fromJson(Map<String, dynamic> json) => StreamModel(
        channel: json["channel"],
        feed: json["feed"],
        title: json["title"],
        url: json["url"],
        quality: null,
        label: null,
        userAgent: json["user_agent"],
        referrer: json["referrer"],
      );

  Map<String, dynamic> toJson() => {
        "channel": channel,
        "feed": feed,
        "title": title,
        "url": url,
        "quality": qualityValues.reverse[quality],
        "label": labelValues.reverse[label],
        "user_agent": userAgent,
        "referrer": referrer,
      };
}

enum Label {
  GEO_BLOCKED,
  GEO_BLOCKED_GEO_BLOCKED,
  GEO_BLOCKED_NOT_247,
  LABEL_GEO_BLOCKED,
  LABEL_NOT_247,
  NON_GEO_BLOCKED,
  NOT_247,
  NOT_247_GEO_BLOCKED,
  PURPLE_NOT_247
}

final labelValues = EnumValues({
  "Geo-blocked": Label.GEO_BLOCKED,
  "Geo-blocked] [Geo-Blocked": Label.GEO_BLOCKED_GEO_BLOCKED,
  "Geo-blocked] [Not 24/7": Label.GEO_BLOCKED_NOT_247,
  "Geo-Blocked": Label.LABEL_GEO_BLOCKED,
  "[Not 24/7]": Label.LABEL_NOT_247,
  "Non geo blocked": Label.NON_GEO_BLOCKED,
  "Not 24/7": Label.NOT_247,
  "Not 24/7] [Geo-blocked": Label.NOT_247_GEO_BLOCKED,
  "Not 24 7": Label.PURPLE_NOT_247
});

enum Quality {
  THE_1024_P,
  THE_1080_I,
  THE_1080_P,
  THE_1088_P,
  THE_1280_P,
  THE_1440_P,
  THE_144_P,
  THE_160_P,
  THE_180_P,
  THE_214_P,
  THE_2160_P,
  THE_220_P,
  THE_224_P,
  THE_226_P,
  THE_240_P,
  THE_260_P,
  THE_268_P,
  THE_270_P,
  THE_288_P,
  THE_300_P,
  THE_320_P,
  THE_349_P,
  THE_352_P,
  THE_360_P,
  THE_368_P,
  THE_384_P,
  THE_392_P,
  THE_396_P,
  THE_400_P,
  THE_404_P,
  THE_406_P,
  THE_410_P,
  THE_412_P,
  THE_416_P,
  THE_420_P,
  THE_432_P,
  THE_440_P,
  THE_450_P,
  THE_472_P,
  THE_480_I,
  THE_480_P,
  THE_486_P,
  THE_504_P,
  THE_512_P,
  THE_540_P,
  THE_544_P,
  THE_548_P,
  THE_552_P,
  THE_560_P,
  THE_562_P,
  THE_564_P,
  THE_568_P,
  THE_576_I,
  THE_576_P,
  THE_582_P,
  THE_600_P,
  THE_614_P,
  THE_616_P,
  THE_620_P,
  THE_636_P,
  THE_640_P,
  THE_642_P,
  THE_648_P,
  THE_672_P,
  THE_712_P,
  THE_714_P,
  THE_718_P,
  THE_720_P,
  THE_751_P,
  THE_768_P,
  THE_854_P,
  THE_900_P,
  THE_960_P
}

final qualityValues = EnumValues({
  "1024p": Quality.THE_1024_P,
  "1080i": Quality.THE_1080_I,
  "1080p": Quality.THE_1080_P,
  "1088p": Quality.THE_1088_P,
  "1280p": Quality.THE_1280_P,
  "1440p": Quality.THE_1440_P,
  "144p": Quality.THE_144_P,
  "160p": Quality.THE_160_P,
  "180p": Quality.THE_180_P,
  "214p": Quality.THE_214_P,
  "2160p": Quality.THE_2160_P,
  "220p": Quality.THE_220_P,
  "224p": Quality.THE_224_P,
  "226p": Quality.THE_226_P,
  "240p": Quality.THE_240_P,
  "260p": Quality.THE_260_P,
  "268p": Quality.THE_268_P,
  "270p": Quality.THE_270_P,
  "288p": Quality.THE_288_P,
  "300p": Quality.THE_300_P,
  "320p": Quality.THE_320_P,
  "349p": Quality.THE_349_P,
  "352p": Quality.THE_352_P,
  "360p": Quality.THE_360_P,
  "368p": Quality.THE_368_P,
  "384p": Quality.THE_384_P,
  "392p": Quality.THE_392_P,
  "396p": Quality.THE_396_P,
  "400p": Quality.THE_400_P,
  "404p": Quality.THE_404_P,
  "406p": Quality.THE_406_P,
  "410p": Quality.THE_410_P,
  "412p": Quality.THE_412_P,
  "416p": Quality.THE_416_P,
  "420p": Quality.THE_420_P,
  "432p": Quality.THE_432_P,
  "440p": Quality.THE_440_P,
  "450p": Quality.THE_450_P,
  "472p": Quality.THE_472_P,
  "480i": Quality.THE_480_I,
  "480p": Quality.THE_480_P,
  "486p": Quality.THE_486_P,
  "504p": Quality.THE_504_P,
  "512p": Quality.THE_512_P,
  "540p": Quality.THE_540_P,
  "544p": Quality.THE_544_P,
  "548p": Quality.THE_548_P,
  "552p": Quality.THE_552_P,
  "560p": Quality.THE_560_P,
  "562p": Quality.THE_562_P,
  "564p": Quality.THE_564_P,
  "568p": Quality.THE_568_P,
  "576i": Quality.THE_576_I,
  "576p": Quality.THE_576_P,
  "582p": Quality.THE_582_P,
  "600p": Quality.THE_600_P,
  "614p": Quality.THE_614_P,
  "616p": Quality.THE_616_P,
  "620p": Quality.THE_620_P,
  "636p": Quality.THE_636_P,
  "640p": Quality.THE_640_P,
  "642p": Quality.THE_642_P,
  "648p": Quality.THE_648_P,
  "672p": Quality.THE_672_P,
  "712p": Quality.THE_712_P,
  "714p": Quality.THE_714_P,
  "718p": Quality.THE_718_P,
  "720p": Quality.THE_720_P,
  "751p": Quality.THE_751_P,
  "768p": Quality.THE_768_P,
  "854p": Quality.THE_854_P,
  "900p": Quality.THE_900_P,
  "960p": Quality.THE_960_P
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
