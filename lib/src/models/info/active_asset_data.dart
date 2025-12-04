import 'package:json_annotation/json_annotation.dart';
import 'clearinghouse_state.dart';

part 'active_asset_data.g.dart';

@JsonSerializable()
class ActiveAssetData {
  final String user;
  final String coin;
  final Leverage leverage;
  final List<dynamic> maxTradeSzs;
  final List<dynamic> availableToTrade;
  final String markPx;

  ActiveAssetData({
    required this.user,
    required this.coin,
    required this.leverage,
    required this.maxTradeSzs,
    required this.availableToTrade,
    required this.markPx,
  });

  factory ActiveAssetData.fromJson(Map<String, dynamic> json) =>
      _$ActiveAssetDataFromJson(json);
  Map<String, dynamic> toJson() => _$ActiveAssetDataToJson(this);
}
