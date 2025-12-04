import 'package:hyperliquid_dart/hyperliquid_dart.dart';
import 'dart:async';

void main() async {
  final socket = HyperliquidSocket();

  print('Connecting to WebSocket...');
  await socket.connect();
  print('Connected.');

  // Subscribe to L2 Book for BTC
  print('Subscribing to L2 Book for BTC...');
  socket.subscribeToL2Book('BTC');

  // Subscribe to All Mids
  print('Subscribing to All Mids...');
  socket.subscribeToAllMids();

  // Listen for messages for 10 seconds
  final subscription = socket.stream.listen((message) {
    if (message is L2BookEvent) {
      print('Received L2 Book update for ${message.data.coin}');
    } else if (message is AllMidsEvent) {
      print('Received All Mids update: ${message.data.length} assets');
    } else if (message is TradeEvent) {
      print('Received Trades update: ${message.data.length} trades');
    } else {
      print('Received message: ${message.channel}');
    }
  });

  await Future.delayed(Duration(seconds: 10));
  print('Closing connection...');
  await subscription.cancel();
  await socket.close();
  print('Closed.');
}
