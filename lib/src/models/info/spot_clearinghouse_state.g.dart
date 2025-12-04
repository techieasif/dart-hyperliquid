// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot_clearinghouse_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpotClearinghouseState _$SpotClearinghouseStateFromJson(
        Map<String, dynamic> json) =>
    SpotClearinghouseState(
      balances: (json['balances'] as List<dynamic>)
          .map((e) => SpotBalance.fromJson(e as Map<String, dynamic>))
          .toList(),
      evmEscrows: (json['evmEscrows'] as List<dynamic>?)
          ?.map((e) => EvmEscrow.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SpotClearinghouseStateToJson(
        SpotClearinghouseState instance) =>
    <String, dynamic>{
      'balances': instance.balances,
      'evmEscrows': instance.evmEscrows,
    };

SpotBalance _$SpotBalanceFromJson(Map<String, dynamic> json) => SpotBalance(
      coin: json['coin'] as String,
      token: (json['token'] as num).toInt(),
      total: json['total'] as String,
      hold: json['hold'] as String,
      entryNtl: json['entryNtl'] as String,
    );

Map<String, dynamic> _$SpotBalanceToJson(SpotBalance instance) =>
    <String, dynamic>{
      'coin': instance.coin,
      'token': instance.token,
      'total': instance.total,
      'hold': instance.hold,
      'entryNtl': instance.entryNtl,
    };

EvmEscrow _$EvmEscrowFromJson(Map<String, dynamic> json) => EvmEscrow(
      coin: json['coin'] as String,
      token: (json['token'] as num).toInt(),
      total: json['total'] as String,
    );

Map<String, dynamic> _$EvmEscrowToJson(EvmEscrow instance) => <String, dynamic>{
      'coin': instance.coin,
      'token': instance.token,
      'total': instance.total,
    };
