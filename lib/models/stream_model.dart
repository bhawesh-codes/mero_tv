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

  factory StreamModel.fromJson(Map<String, dynamic> json) => _$StreamModelFromJson(json);

  Map<String, dynamic> toJson() => _$StreamModelToJson(this);
}

enum Label {
  geoBlocked,
  geoBlockedGeoBlocked,
  geoBlockedNot247,
  labelGeoBlocked,
  labelNot247,
  nonGeoBlocked,
  not247,
  not247GeoBlocked,
  purpleNot247,
}

final labelValues = EnumValues({
  "Geo-blocked": Label.geoBlocked,
  "Geo-blocked] [Geo-Blocked": Label.geoBlockedGeoBlocked,
  "Geo-blocked] [Not 24/7": Label.geoBlockedNot247,
  "Geo-Blocked": Label.labelGeoBlocked,
  "[Not 24/7]": Label.labelNot247,
  "Non geo blocked": Label.nonGeoBlocked,
  "Not 24/7": Label.not247,
  "Not 24/7] [Geo-blocked": Label.not247GeoBlocked,
  "Not 24 7": Label.purpleNot247,
});

enum Quality {
  the1024P,
  the1080I,
  the1080P,
  the1088P,
  the1280P,
  the1440P,
  the144P,
  the160P,
  the180P,
  the214P,
  the2160P,
  the220P,
  the224P,
  the226P,
  the240P,
  the260P,
  the268P,
  the270P,
  the288P,
  the300P,
  the320P,
  the349P,
  the352P,
  the360P,
  the368P,
  the384P,
  the392P,
  the396P,
  the400P,
  the404P,
  the406P,
  the410P,
  the412P,
  the416P,
  the420P,
  the432P,
  the440P,
  the450P,
  the472P,
  the480I,
  the480P,
  the486P,
  the504P,
  the512P,
  the540P,
  the544P,
  the548P,
  the552P,
  the560P,
  the562P,
  the564P,
  the568P,
  the576I,
  the576P,
  the582P,
  the600P,
  the614P,
  the616P,
  the620P,
  the636P,
  the640P,
  the642P,
  the648P,
  the672P,
  the712P,
  the714P,
  the718P,
  the720P,
  the751P,
  the768P,
  the854P,
  the900P,
  the960P,
}

final qualityValues = EnumValues({
  "1024p": Quality.the1024P,
  "1080i": Quality.the1080I,
  "1080p": Quality.the1080P,
  "1088p": Quality.the1088P,
  "1280p": Quality.the1280P,
  "1440p": Quality.the1440P,
  "144p": Quality.the144P,
  "160p": Quality.the160P,
  "180p": Quality.the180P,
  "214p": Quality.the214P,
  "2160p": Quality.the2160P,
  "220p": Quality.the220P,
  "224p": Quality.the224P,
  "226p": Quality.the226P,
  "240p": Quality.the240P,
  "260p": Quality.the260P,
  "268p": Quality.the268P,
  "270p": Quality.the270P,
  "288p": Quality.the288P,
  "300p": Quality.the300P,
  "320p": Quality.the320P,
  "349p": Quality.the349P,
  "352p": Quality.the352P,
  "360p": Quality.the360P,
  "368p": Quality.the368P,
  "384p": Quality.the384P,
  "392p": Quality.the392P,
  "396p": Quality.the396P,
  "400p": Quality.the400P,
  "404p": Quality.the404P,
  "406p": Quality.the406P,
  "410p": Quality.the410P,
  "412p": Quality.the412P,
  "416p": Quality.the416P,
  "420p": Quality.the420P,
  "432p": Quality.the432P,
  "440p": Quality.the440P,
  "450p": Quality.the450P,
  "472p": Quality.the472P,
  "480i": Quality.the480I,
  "480p": Quality.the480P,
  "486p": Quality.the486P,
  "504p": Quality.the504P,
  "512p": Quality.the512P,
  "540p": Quality.the540P,
  "544p": Quality.the544P,
  "548p": Quality.the548P,
  "552p": Quality.the552P,
  "560p": Quality.the560P,
  "562p": Quality.the562P,
  "564p": Quality.the564P,
  "568p": Quality.the568P,
  "576i": Quality.the576I,
  "576p": Quality.the576P,
  "582p": Quality.the582P,
  "600p": Quality.the600P,
  "614p": Quality.the614P,
  "616p": Quality.the616P,
  "620p": Quality.the620P,
  "636p": Quality.the636P,
  "640p": Quality.the640P,
  "642p": Quality.the642P,
  "648p": Quality.the648P,
  "672p": Quality.the672P,
  "712p": Quality.the712P,
  "714p": Quality.the714P,
  "718p": Quality.the718P,
  "720p": Quality.the720P,
  "751p": Quality.the751P,
  "768p": Quality.the768P,
  "854p": Quality.the854P,
  "900p": Quality.the900P,
  "960p": Quality.the960P
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
