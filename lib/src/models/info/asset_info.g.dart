// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetInfo _$AssetInfoFromJson(Map<String, dynamic> json) => AssetInfo(
      name: json['name'] as String,
      szDecimals: (json['szDecimals'] as num).toInt(),
      maxLeverage: (json['maxLeverage'] as num).toInt(),
      onlyIsolated: json['onlyIsolated'] as bool?,
      isDelisted: json['isDelisted'] as bool?,
    );

Map<String, dynamic> _$AssetInfoToJson(AssetInfo instance) => <String, dynamic>{
      'name': instance.name,
      'szDecimals': instance.szDecimals,
      'maxLeverage': instance.maxLeverage,
      'onlyIsolated': instance.onlyIsolated,
      'isDelisted': instance.isDelisted,
    };
