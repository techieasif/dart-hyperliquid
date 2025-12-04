import 'package:json_annotation/json_annotation.dart';

part 'open_order.g.dart';

@JsonSerializable()
class OpenOrder {
  final String coin;
  final String side;
  final String limitPx;
  final String sz;
  final int oid;
  final int timestamp;
  final String origSz;
  final String? cloid;
  final bool reduceOnly;

  OpenOrder({
    required this.coin,
    required this.side,
    required this.limitPx,
    required this.sz,
    required this.oid,
    required this.timestamp,
    required this.origSz,
    this.cloid,
    required this.reduceOnly,
  });

  factory OpenOrder.fromJson(Map<String, dynamic> json) =>
      _$OpenOrderFromJson(json);
  Map<String, dynamic> toJson() => _$OpenOrderToJson(this);
}
