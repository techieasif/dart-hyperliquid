// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpotMeta _$SpotMetaFromJson(Map<String, dynamic> json) => SpotMeta(
      universe: (json['universe'] as List<dynamic>)
          .map((e) => SpotUniverse.fromJson(e as Map<String, dynamic>))
          .toList(),
      tokens: (json['tokens'] as List<dynamic>)
          .map((e) => SpotToken.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SpotMetaToJson(SpotMeta instance) => <String, dynamic>{
      'universe': instance.universe,
      'tokens': instance.tokens,
    };

SpotUniverse _$SpotUniverseFromJson(Map<String, dynamic> json) => SpotUniverse(
      tokens: (json['tokens'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      name: json['name'] as String,
      index: (json['index'] as num).toInt(),
      isCanonical: json['isCanonical'] as bool,
    );

Map<String, dynamic> _$SpotUniverseToJson(SpotUniverse instance) =>
    <String, dynamic>{
      'tokens': instance.tokens,
      'name': instance.name,
      'index': instance.index,
      'isCanonical': instance.isCanonical,
    };

SpotToken _$SpotTokenFromJson(Map<String, dynamic> json) => SpotToken(
      name: json['name'] as String,
      szDecimals: (json['szDecimals'] as num).toInt(),
      weiDecimals: (json['weiDecimals'] as num).toInt(),
      index: (json['index'] as num).toInt(),
      tokenId: json['tokenId'] as String,
      isCanonical: json['isCanonical'] as bool,
      evmContract: json['evmContract'] == null
          ? null
          : EvmContract.fromJson(json['evmContract'] as Map<String, dynamic>),
      fullName: json['fullName'] as String?,
      deployerTradingFeeShare: json['deployerTradingFeeShare'] as String?,
    );

Map<String, dynamic> _$SpotTokenToJson(SpotToken instance) => <String, dynamic>{
      'name': instance.name,
      'szDecimals': instance.szDecimals,
      'weiDecimals': instance.weiDecimals,
      'index': instance.index,
      'tokenId': instance.tokenId,
      'isCanonical': instance.isCanonical,
      'evmContract': instance.evmContract,
      'fullName': instance.fullName,
      'deployerTradingFeeShare': instance.deployerTradingFeeShare,
    };

EvmContract _$EvmContractFromJson(Map<String, dynamic> json) => EvmContract(
      address: json['address'] as String,
      evmExtraWeiDecimals: (json['evm_extra_wei_decimals'] as num).toInt(),
    );

Map<String, dynamic> _$EvmContractToJson(EvmContract instance) =>
    <String, dynamic>{
      'address': instance.address,
      'evm_extra_wei_decimals': instance.evmExtraWeiDecimals,
    };
