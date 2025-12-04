import 'package:json_annotation/json_annotation.dart';

part 'clearinghouse_state.g.dart';

@JsonSerializable()
class ClearinghouseState {
  final MarginSummary marginSummary;
  final MarginSummary crossMarginSummary;
  final String crossMaintenanceMarginUsed;
  final String withdrawable;
  final List<AssetPosition> assetPositions;
  final int time;

  ClearinghouseState({
    required this.marginSummary,
    required this.crossMarginSummary,
    required this.crossMaintenanceMarginUsed,
    required this.withdrawable,
    required this.assetPositions,
    required this.time,
  });

  factory ClearinghouseState.fromJson(Map<String, dynamic> json) =>
      _$ClearinghouseStateFromJson(json);
  Map<String, dynamic> toJson() => _$ClearinghouseStateToJson(this);
}

@JsonSerializable()
class MarginSummary {
  final String accountValue;
  final String totalNtlPos;
  final String totalRawUsd;
  final String totalMarginUsed;

  MarginSummary({
    required this.accountValue,
    required this.totalNtlPos,
    required this.totalRawUsd,
    required this.totalMarginUsed,
  });

  factory MarginSummary.fromJson(Map<String, dynamic> json) =>
      _$MarginSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$MarginSummaryToJson(this);
}

@JsonSerializable()
class AssetPosition {
  final String type;
  final Position position;

  AssetPosition({required this.type, required this.position});

  factory AssetPosition.fromJson(Map<String, dynamic> json) =>
      _$AssetPositionFromJson(json);
  Map<String, dynamic> toJson() => _$AssetPositionToJson(this);
}

@JsonSerializable()
class Position {
  final String coin;
  final String szi;
  final Leverage leverage;
  final String entryPx;
  final String positionValue;
  final String unrealizedPnl;
  final String returnOnEquity;
  final String liquidationPx;
  final String marginUsed;
  final int maxLeverage;
  final CumFunding cumFunding;

  Position({
    required this.coin,
    required this.szi,
    required this.leverage,
    required this.entryPx,
    required this.positionValue,
    required this.unrealizedPnl,
    required this.returnOnEquity,
    required this.liquidationPx,
    required this.marginUsed,
    required this.maxLeverage,
    required this.cumFunding,
  });

  factory Position.fromJson(Map<String, dynamic> json) =>
      _$PositionFromJson(json);
  Map<String, dynamic> toJson() => _$PositionToJson(this);
}

@JsonSerializable()
class Leverage {
  final String type;
  final int value;
  final String? rawUsd;

  Leverage({required this.type, required this.value, this.rawUsd});

  factory Leverage.fromJson(Map<String, dynamic> json) =>
      _$LeverageFromJson(json);
  Map<String, dynamic> toJson() => _$LeverageToJson(this);
}

@JsonSerializable()
class CumFunding {
  final String allTime;
  final String sinceOpen;
  final String sinceChange;

  CumFunding({
    required this.allTime,
    required this.sinceOpen,
    required this.sinceChange,
  });

  factory CumFunding.fromJson(Map<String, dynamic> json) =>
      _$CumFundingFromJson(json);
  Map<String, dynamic> toJson() => _$CumFundingToJson(this);
}
