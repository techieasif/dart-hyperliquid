// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderRequest _$OrderRequestFromJson(Map<String, dynamic> json) => OrderRequest(
      assetIndex: (json['a'] as num).toInt(),
      isBuy: json['b'] as bool,
      price: json['p'] as String,
      size: json['s'] as String,
      reduceOnly: json['r'] as bool,
      orderType: json['t'] as Map<String, dynamic>,
      cloid: json['c'] as String?,
    );

Map<String, dynamic> _$OrderRequestToJson(OrderRequest instance) =>
    <String, dynamic>{
      'a': instance.assetIndex,
      'b': instance.isBuy,
      'p': instance.price,
      's': instance.size,
      'r': instance.reduceOnly,
      't': instance.orderType,
      'c': instance.cloid,
    };
