import 'package:json_annotation/json_annotation.dart';
import '../info/l2_book.dart';
import 'ws_message.dart';

part 'l2_book_event.g.dart';

@JsonSerializable()
class L2BookEvent extends WsMessage {
  final L2Book data;

  L2BookEvent({
    required this.data,
  }) : super('l2Book');

  factory L2BookEvent.fromJson(Map<String, dynamic> json) =>
      _$L2BookEventFromJson(json);

  Map<String, dynamic> toJson() => _$L2BookEventToJson(this);
}
