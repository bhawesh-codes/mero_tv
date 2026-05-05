// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StreamModelAdapter extends TypeAdapter<StreamModel> {
  @override
  final int typeId = 0;

  @override
  StreamModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StreamModel(
      channel: fields[0] as String?,
      feed: fields[1] as String?,
      title: fields[2] as String?,
      url: fields[3] as String?,
      quality: fields[4] as String?,
      label: fields[5] as String?,
      userAgent: fields[6] as String?,
      referrer: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StreamModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.channel)
      ..writeByte(1)
      ..write(obj.feed)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.url)
      ..writeByte(4)
      ..write(obj.quality)
      ..writeByte(5)
      ..write(obj.label)
      ..writeByte(6)
      ..write(obj.userAgent)
      ..writeByte(7)
      ..write(obj.referrer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StreamModel _$StreamModelFromJson(Map<String, dynamic> json) => StreamModel(
      channel: json['channel'] as String?,
      feed: json['feed'] as String?,
      title: json['title'] as String?,
      url: json['url'] as String?,
      quality: json['quality'] as String?,
      label: json['label'] as String?,
      userAgent: json['user_agent'] as String?,
      referrer: json['referrer'] as String?,
    );

Map<String, dynamic> _$StreamModelToJson(StreamModel instance) =>
    <String, dynamic>{
      'channel': instance.channel,
      'feed': instance.feed,
      'title': instance.title,
      'url': instance.url,
      'quality': instance.quality,
      'label': instance.label,
      'user_agent': instance.userAgent,
      'referrer': instance.referrer,
    };
