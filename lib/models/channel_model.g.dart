// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChannelModelAdapter extends TypeAdapter<ChannelModel> {
  @override
  final int typeId = 0;

  @override
  ChannelModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChannelModel(
      id: fields[0] as String?,
      name: fields[1] as String?,
      altNames: (fields[2] as List?)?.cast<String>(),
      network: fields[3] as String?,
      owners: (fields[4] as List?)?.cast<String>(),
      country: fields[5] as String?,
      categories: (fields[6] as List?)?.cast<Category>(),
      isNsfw: fields[7] as bool?,
      launched: fields[8] as DateTime?,
      closed: fields[9] as DateTime?,
      replacedBy: fields[10] as String?,
      website: fields[11] as String?,
      logoUrl: fields[12] as String?,
      streamUrl: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ChannelModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.altNames)
      ..writeByte(3)
      ..write(obj.network)
      ..writeByte(4)
      ..write(obj.owners)
      ..writeByte(5)
      ..write(obj.country)
      ..writeByte(6)
      ..write(obj.categories)
      ..writeByte(7)
      ..write(obj.isNsfw)
      ..writeByte(8)
      ..write(obj.launched)
      ..writeByte(9)
      ..write(obj.closed)
      ..writeByte(10)
      ..write(obj.replacedBy)
      ..writeByte(11)
      ..write(obj.website)
      ..writeByte(12)
      ..write(obj.logoUrl)
      ..writeByte(13)
      ..write(obj.streamUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChannelModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 1;

  @override
  Category read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Category.animation;
      case 1:
        return Category.auto;
      case 2:
        return Category.business;
      case 3:
        return Category.classic;
      case 4:
        return Category.comedy;
      case 5:
        return Category.cooking;
      case 6:
        return Category.culture;
      case 7:
        return Category.documentary;
      case 8:
        return Category.education;
      case 9:
        return Category.entertainment;
      case 10:
        return Category.family;
      case 11:
        return Category.general;
      case 12:
        return Category.interactive;
      case 13:
        return Category.kids;
      case 14:
        return Category.legislative;
      case 15:
        return Category.lifestyle;
      case 16:
        return Category.movies;
      case 17:
        return Category.music;
      case 18:
        return Category.news;
      case 19:
        return Category.outdoor;
      case 20:
        return Category.public;
      case 21:
        return Category.relax;
      case 22:
        return Category.religious;
      case 23:
        return Category.science;
      case 24:
        return Category.series;
      case 25:
        return Category.shop;
      case 26:
        return Category.sports;
      case 27:
        return Category.travel;
      case 28:
        return Category.weather;
      case 29:
        return Category.xxx;
      default:
        return Category.animation;
    }
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    switch (obj) {
      case Category.animation:
        writer.writeByte(0);
        break;
      case Category.auto:
        writer.writeByte(1);
        break;
      case Category.business:
        writer.writeByte(2);
        break;
      case Category.classic:
        writer.writeByte(3);
        break;
      case Category.comedy:
        writer.writeByte(4);
        break;
      case Category.cooking:
        writer.writeByte(5);
        break;
      case Category.culture:
        writer.writeByte(6);
        break;
      case Category.documentary:
        writer.writeByte(7);
        break;
      case Category.education:
        writer.writeByte(8);
        break;
      case Category.entertainment:
        writer.writeByte(9);
        break;
      case Category.family:
        writer.writeByte(10);
        break;
      case Category.general:
        writer.writeByte(11);
        break;
      case Category.interactive:
        writer.writeByte(12);
        break;
      case Category.kids:
        writer.writeByte(13);
        break;
      case Category.legislative:
        writer.writeByte(14);
        break;
      case Category.lifestyle:
        writer.writeByte(15);
        break;
      case Category.movies:
        writer.writeByte(16);
        break;
      case Category.music:
        writer.writeByte(17);
        break;
      case Category.news:
        writer.writeByte(18);
        break;
      case Category.outdoor:
        writer.writeByte(19);
        break;
      case Category.public:
        writer.writeByte(20);
        break;
      case Category.relax:
        writer.writeByte(21);
        break;
      case Category.religious:
        writer.writeByte(22);
        break;
      case Category.science:
        writer.writeByte(23);
        break;
      case Category.series:
        writer.writeByte(24);
        break;
      case Category.shop:
        writer.writeByte(25);
        break;
      case Category.sports:
        writer.writeByte(26);
        break;
      case Category.travel:
        writer.writeByte(27);
        break;
      case Category.weather:
        writer.writeByte(28);
        break;
      case Category.xxx:
        writer.writeByte(29);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
      logoUrl: json['logoUrl'] as String?,
      streamUrl: json['streamUrl'] as String?,
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
      'logoUrl': instance.logoUrl,
      'streamUrl': instance.streamUrl,
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
