// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelModel _$ChannelModelFromJson(Map<String, dynamic> json) => ChannelModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      altNames: (json['altNames'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      network: json['network'] as String?,
      owners:
          (json['owners'] as List<dynamic>?)?.map((e) => e as String).toList(),
      country: json['country'] as String?,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$CategoryEnumMap, e))
          .toList(),
      isNsfw: json['isNsfw'] as bool?,
      launched: json['launched'] == null
          ? null
          : DateTime.parse(json['launched'] as String),
      closed: json['closed'] == null
          ? null
          : DateTime.parse(json['closed'] as String),
      replacedBy: json['replacedBy'] as String?,
      website: json['website'] as String?,
    );

Map<String, dynamic> _$ChannelModelToJson(ChannelModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'altNames': instance.altNames,
      'network': instance.network,
      'owners': instance.owners,
      'country': instance.country,
      'categories':
          instance.categories?.map((e) => _$CategoryEnumMap[e]!).toList(),
      'isNsfw': instance.isNsfw,
      'launched': instance.launched?.toIso8601String(),
      'closed': instance.closed?.toIso8601String(),
      'replacedBy': instance.replacedBy,
      'website': instance.website,
    };

const _$CategoryEnumMap = {
  Category.animation: 'animation',
  Category.auto: 'auto',
  Category.business: 'business',
  Category.classic: 'classic',
  Category.comedy: 'comedy',
  Category.cooking: 'cooking',
  Category.culture: 'culture',
  Category.documentary: 'documentary',
  Category.education: 'education',
  Category.entertainment: 'entertainment',
  Category.family: 'family',
  Category.general: 'general',
  Category.interactive: 'interactive',
  Category.kids: 'kids',
  Category.legislative: 'legislative',
  Category.lifestyle: 'lifestyle',
  Category.movies: 'movies',
  Category.music: 'music',
  Category.news: 'news',
  Category.outdoor: 'outdoor',
  Category.public: 'public',
  Category.relax: 'relax',
  Category.religious: 'religious',
  Category.science: 'science',
  Category.series: 'series',
  Category.shop: 'shop',
  Category.sports: 'sports',
  Category.travel: 'travel',
  Category.weather: 'weather',
  Category.xxx: 'xxx',
};
