# WebSocket API

The `HyperliquidSocket` provides real-time access to market data and user events.

## Connection

```dart
final socket = HyperliquidSocket();
await socket.connect();
```

## Subscriptions

### L2 Book
Subscribe to real-time order book updates.

```dart
socket.subscribeToL2Book('BTC');
```

### Trades
Subscribe to real-time trades.

```dart
socket.subscribeToTrades('ETH');
```

### User Events
Subscribe to your own fills and account updates.

```dart
socket.subscribeToUserEvents('0xYourAddress...');
```

## Handling Events

The SDK provides a typed stream of events. You can listen to `socket.stream` and check the type of the event.

```dart
socket.stream.listen((message) {
  if (message is L2BookEvent) {
    print('Book Update: ${message.data.coin}');
  } else if (message is TradeEvent) {
    print('New Trades: ${message.data.length}');
  } else if (message is UserEvent) {
    print('User Update: ${message.data}');
  }
});
```

## Closing

```dart
await socket.close();
```
