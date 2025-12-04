import 'package:json_annotation/json_annotation.dart';

part 'asset_info.g.dart';

@JsonSerializable()
class AssetInfo {
  final String name;
  final int szDecimals;
  final int maxLeverage;
  final bool? onlyIsolated;
  final bool? isDelisted;

  AssetInfo({
    required this.name,
    required this.szDecimals,
    required this.maxLeverage,
    this.onlyIsolated,
    this.isDelisted,
  });

  factory AssetInfo.fromJson(Map<String, dynamic> json) =>
      _$AssetInfoFromJson(json);

  Map<String, dynamic> toJson() => _$AssetInfoToJson(this);
}
