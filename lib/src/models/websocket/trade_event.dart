import 'package:json_annotation/json_annotation.dart';
import 'ws_message.dart';

part 'trade_event.g.dart';

@JsonSerializable()
class TradeEvent extends WsMessage {
  final List<WsTrade> data;

  TradeEvent({
    required this.data,
  }) : super('trades');

  factory TradeEvent.fromJson(Map<String, dynamic> json) =>
      _$TradeEventFromJson(json);

  Map<String, dynamic> toJson() => _$TradeEventToJson(this);
}

@JsonSerializable()
class WsTrade {
  final String coin;
  final String side;
  final String px;
  final String sz;
  final int time;
  final String hash;

  WsTrade({
    required this.coin,
    required this.side,
    required this.px,
    required this.sz,
    required this.time,
    required this.hash,
  });

  factory WsTrade.fromJson(Map<String, dynamic> json) =>
      _$WsTradeFromJson(json);

  Map<String, dynamic> toJson() => _$WsTradeToJson(this);
}
