import 'package:json_annotation/json_annotation.dart';

part 'spot_meta.g.dart';

@JsonSerializable()
class SpotMeta {
  final List<SpotUniverse> universe;
  final List<SpotToken> tokens;

  SpotMeta({required this.universe, required this.tokens});

  factory SpotMeta.fromJson(Map<String, dynamic> json) =>
      _$SpotMetaFromJson(json);
  Map<String, dynamic> toJson() => _$SpotMetaToJson(this);
}

@JsonSerializable()
class SpotUniverse {
  final List<int> tokens;
  final String name;
  final int index;
  final bool isCanonical;

  SpotUniverse({
    required this.tokens,
    required this.name,
    required this.index,
    required this.isCanonical,
  });

  factory SpotUniverse.fromJson(Map<String, dynamic> json) =>
      _$SpotUniverseFromJson(json);
  Map<String, dynamic> toJson() => _$SpotUniverseToJson(this);
}

@JsonSerializable()
class SpotToken {
  final String name;
  final int szDecimals;
  final int weiDecimals;
  final int index;
  final String tokenId;
  final bool isCanonical;
  final EvmContract? evmContract;
  final String? fullName;
  final String? deployerTradingFeeShare;

  SpotToken({
    required this.name,
    required this.szDecimals,
    required this.weiDecimals,
    required this.index,
    required this.tokenId,
    required this.isCanonical,
    this.evmContract,
    this.fullName,
    this.deployerTradingFeeShare,
  });

  factory SpotToken.fromJson(Map<String, dynamic> json) =>
      _$SpotTokenFromJson(json);
  Map<String, dynamic> toJson() => _$SpotTokenToJson(this);
}

@JsonSerializable()
class EvmContract {
  final String address;
  @JsonKey(name: 'evm_extra_wei_decimals')
  final int evmExtraWeiDecimals;

  EvmContract({required this.address, required this.evmExtraWeiDecimals});

  factory EvmContract.fromJson(Map<String, dynamic> json) =>
      _$EvmContractFromJson(json);
  Map<String, dynamic> toJson() => _$EvmContractToJson(this);
}
