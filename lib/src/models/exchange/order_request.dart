import 'package:json_annotation/json_annotation.dart';

part 'order_request.g.dart';

@JsonSerializable()
class OrderRequest {
  @JsonKey(name: 'a')
  final int assetIndex;

  @JsonKey(name: 'b')
  final bool isBuy;

  @JsonKey(name: 'p')
  final String price;

  @JsonKey(name: 's')
  final String size;

  @JsonKey(name: 'r')
  final bool reduceOnly;

  @JsonKey(name: 't')
  final Map<String, dynamic> orderType;

  @JsonKey(name: 'c')
  final String? cloid;

  OrderRequest({
    required this.assetIndex,
    required this.isBuy,
    required this.price,
    required this.size,
    required this.reduceOnly,
    required this.orderType,
    this.cloid,
  });

  factory OrderRequest.fromJson(Map<String, dynamic> json) =>
      _$OrderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$OrderRequestToJson(this);
}

class OrderType {
  static Map<String, dynamic> limit({required String tif}) {
    return {
      'limit': {'tif': tif}
    };
  }

  static Map<String, dynamic> trigger({
    required bool isMarket,
    required String triggerPx,
    required String tpsl,
  }) {
    return {
      'trigger': {
        'isMarket': isMarket,
        'triggerPx': triggerPx,
        'tpsl': tpsl,
      }
    };
  }
}
