import 'package:json_annotation/json_annotation.dart';
import 'asset_info.dart';

part 'meta.g.dart';

@JsonSerializable()
class Meta {
  final List<AssetInfo> universe;

  Meta({
    required this.universe,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

  Map<String, dynamic> toJson() => _$MetaToJson(this);
}
