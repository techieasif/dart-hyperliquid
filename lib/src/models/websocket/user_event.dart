import 'package:json_annotation/json_annotation.dart';
import 'ws_message.dart';

part 'user_event.g.dart';

@JsonSerializable()
class UserEvent extends WsMessage {
  final dynamic data; // Can be fills, funding, etc.

  UserEvent({
    required this.data,
  }) : super('user');

  factory UserEvent.fromJson(Map<String, dynamic> json) =>
      _$UserEventFromJson(json);

  Map<String, dynamic> toJson() => _$UserEventToJson(this);
}
