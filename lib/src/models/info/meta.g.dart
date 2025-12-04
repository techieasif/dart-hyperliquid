// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
      universe: (json['universe'] as List<dynamic>)
          .map((e) => AssetInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
      'universe': instance.universe,
    };
