import 'package:json_annotation/json_annotation.dart';

part 'spot_clearinghouse_state.g.dart';

@JsonSerializable()
class SpotClearinghouseState {
  final List<SpotBalance> balances;
  final List<EvmEscrow>? evmEscrows;

  SpotClearinghouseState({required this.balances, this.evmEscrows});

  factory SpotClearinghouseState.fromJson(Map<String, dynamic> json) =>
      _$SpotClearinghouseStateFromJson(json);
  Map<String, dynamic> toJson() => _$SpotClearinghouseStateToJson(this);
}

@JsonSerializable()
class SpotBalance {
  final String coin;
  final int token;
  final String total;
  final String hold;
  final String entryNtl;

  SpotBalance({
    required this.coin,
    required this.token,
    required this.total,
    required this.hold,
    required this.entryNtl,
  });

  factory SpotBalance.fromJson(Map<String, dynamic> json) =>
      _$SpotBalanceFromJson(json);
  Map<String, dynamic> toJson() => _$SpotBalanceToJson(this);
}

@JsonSerializable()
class EvmEscrow {
  final String coin;
  final int token;
  final String total;

  EvmEscrow({
    required this.coin,
    required this.token,
    required this.total,
  });

  factory EvmEscrow.fromJson(Map<String, dynamic> json) =>
      _$EvmEscrowFromJson(json);
  Map<String, dynamic> toJson() => _$EvmEscrowToJson(this);
}
