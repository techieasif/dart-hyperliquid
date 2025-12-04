abstract class WsMessage {
  final String channel;

  WsMessage(this.channel);

  factory WsMessage.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('Subclasses must implement fromJson');
  }
}
