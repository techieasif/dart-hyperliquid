import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/websocket/ws_message.dart';
import '../models/websocket/l2_book_event.dart';
import '../models/websocket/trade_event.dart';
import '../models/websocket/all_mids_event.dart';
import '../models/websocket/user_event.dart';

/// Provides access to the Hyperliquid WebSocket API.
///
/// This class handles the WebSocket connection, subscription management, and event dispatching.
class HyperliquidSocket {
  final String url;
  WebSocketChannel? _channel;
  final _controller = StreamController<WsMessage>.broadcast();
  final Map<String, StreamController<dynamic>> _subscriptions = {};

  /// Creates a new [HyperliquidSocket] instance.
  ///
  /// [url] defaults to the Hyperliquid Mainnet WebSocket URL: `wss://api.hyperliquid.xyz/ws`.
  HyperliquidSocket({this.url = 'wss://api.hyperliquid.xyz/ws'});

  /// Stream of all incoming messages.
  Stream<WsMessage> get stream => _controller.stream;

  /// Connects to the WebSocket.
  Future<void> connect() async {
    if (_channel != null) return;

    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _channel!.stream.listen(
        (message) {
          final data = jsonDecode(message);
          _handleMessage(data);
        },
        onError: (error) {
          print('WebSocket Error: $error');
          _disconnect();
        },
        onDone: () {
          print('WebSocket Closed');
          _disconnect();
        },
      );
    } catch (e) {
      print('Connection failed: $e');
      rethrow;
    }
  }

  void _disconnect() {
    _channel = null;
    // Optional: Implement reconnection logic here
  }

  /// Closes the WebSocket connection.
  Future<void> close() async {
    await _channel?.sink.close();
    _channel = null;
    await _controller.close();
    for (var controller in _subscriptions.values) {
      await controller.close();
    }
  }

  /// Subscribes to the L2 order book for a specific [coin].
  void subscribeToL2Book(String coin) {
    _send({
      'method': 'subscribe',
      'subscription': {'type': 'l2Book', 'coin': coin}
    });
  }

  /// Subscribes to trades for a specific [coin].
  void subscribeToTrades(String coin) {
    _send({
      'method': 'subscribe',
      'subscription': {'type': 'trades', 'coin': coin}
    });
  }

  /// Subscribes to user events for a specific [user].
  void subscribeToUserEvents(String user) {
    _send({
      'method': 'subscribe',
      'subscription': {'type': 'userEvents', 'user': user}
    });
  }

  /// Subscribes to all mid prices.
  void subscribeToAllMids() {
    _send({
      'method': 'subscribe',
      'subscription': {'type': 'allMids'}
    });
  }

  void _send(Map<String, dynamic> data) {
    if (_channel == null) {
      throw Exception('WebSocket not connected');
    }
    _channel!.sink.add(jsonEncode(data));
  }

  void _handleMessage(Map<String, dynamic> data) {
    final channel = data['channel'];

    if (channel == 'l2Book') {
      _controller.add(L2BookEvent.fromJson(data));
    } else if (channel == 'trades') {
      _controller.add(TradeEvent.fromJson(data));
    } else if (channel == 'allMids') {
      _controller.add(AllMidsEvent.fromJson(data));
    } else if (channel == 'user') {
      _controller.add(UserEvent.fromJson(data));
    } else {
      // Handle other messages or unknown types
      // For now, we ignore subscription responses or unknown channels
      // to avoid crashing the stream with unknown types.
      // Alternatively, we could have a GenericEvent.
    }
  }
}
