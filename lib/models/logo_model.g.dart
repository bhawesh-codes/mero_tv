// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogoModel _$LogoModelFromJson(Map<String, dynamic> json) => LogoModel(
      channel: json['channel'] as String?,
      feed: json['feed'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      format: $enumDecodeNullable(_$FormatEnumMap, json['format']),
      url: json['url'] as String?,
    );

Map<String, dynamic> _$LogoModelToJson(LogoModel instance) => <String, dynamic>{
      'channel': instance.channel,
      'feed': instance.feed,
      'tags': instance.tags,
      'width': instance.width,
      'height': instance.height,
      'format': _$FormatEnumMap[instance.format],
      'url': instance.url,
    };

const _$FormatEnumMap = {
  Format.gif: 'GIF',
  Format.jpeg: 'JPEG',
  Format.png: 'PNG',
  Format.svg: 'SVG',
  Format.webP: 'WebP',
};
