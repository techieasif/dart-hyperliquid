# ** EXPERIMENTAL UNDER DEVELOPMENT ** 
# Hyperliquid Dart SDK

A Dart SDK for the [Hyperliquid API](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api), designed to provide a type-safe and easy-to-use wrapper for building trading bots and applications on Hyperliquid.

## Features

- **Info API**: Fetch public data like metadata, asset contexts (mids), user state, and open orders.
- **Exchange API**: Execute trades, cancel orders, and manage positions.
- **Signing**: Built-in EIP-712 signing logic using `web3dart` and `msgpack_dart`, eliminating the need for complex external setups.
- **Type Safety**: Fully typed models for requests and responses.

## Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  hyperliquid_dart: ^0.0.1
```

## SDK Usage Guide

### 1. Initialization

First, create an instance of `HyperliquidClient`. You can optionally pass a custom `Dio` instance or base URL.

```dart
import 'package:hyperliquid_dart/hyperliquid_dart.dart';

void main() {
  // Default connects to Mainnet (https://api.hyperliquid.xyz)
  final client = HyperliquidClient();
  
  // For Testnet:
  // final client = HyperliquidClient(baseUrl: 'https://api.hyperliquid-testnet.xyz');
}
```

### 2. Public Info API

The `InfoApi` allows you to fetch public data without authentication.

```dart
final infoApi = InfoApi(client);

// 1. Get Exchange Metadata (Universe, Margin Tables)
final meta = await infoApi.getMeta();
print('Total assets: ${meta.universe.length}');
print('First asset: ${meta.universe.first.name}'); // e.g., BTC

// 2. Get Current Prices (Mids)
final mids = await infoApi.getAllMids();
print('BTC Price: ${mids['BTC']}');
print('ETH Price: ${mids['ETH']}');

// 3. Get User State (Account Value, Positions)
final userAddress = '0x...';
final userState = await infoApi.getUserState(userAddress);
print('Account Value: ${userState.marginSummary.accountValue}');

// 4. Get Open Orders
final openOrders = await infoApi.getOpenOrders(userAddress);
print('Open Orders: ${openOrders.length}');

// 5. Get L2 Order Book
final l2Book = await infoApi.getL2Book('BTC');
print('Best Bid: ${l2Book.levels[0][0].px}');
```

### 3. Exchange API (Trading)

The `ExchangeApi` requires a private key for signing requests. This SDK handles the complex EIP-712 signing and msgpack serialization for you.

```dart
import 'package:web3dart/web3dart.dart';

// Initialize with your private key
final privateKey = 'YOUR_PRIVATE_KEY_HEX'; // e.g. "0x..."
final wallet = EthPrivateKey.fromHex(privateKey);

// Create Exchange API instance (set isMainnet to false for Testnet)
final exchangeApi = ExchangeApi(client, wallet, isMainnet: true);

// 1. Place an Order
try {
  final result = await exchangeApi.placeOrders([
    OrderRequest(
      assetIndex: 0, // Index for BTC (find this in meta.universe)
      isBuy: true,   // Buy
      price: "30000",
      size: "0.01",
      reduceOnly: false,
      orderType: OrderType.limit(tif: 'Gtc'), // Good Til Cancelled
    )
  ]);
  print('Order placed: $result');
} catch (e) {
  print('Order failed: $e');
}

// 2. Cancel an Order
await exchangeApi.cancelOrder('BTC', 123456789);

// 3. Update Leverage
await exchangeApi.updateLeverage('BTC', true, 20); // Cross, 20x

// 4. Transfer Funds (USD)
await exchangeApi.usdSend('0xRecipient...', 100.0);

// 5. Withdraw to L1
await exchangeApi.withdraw3('0xL1Address...', 1000.0);
```

### 4. WebSocket API (Real-time Data)

The `HyperliquidSocket` allows you to subscribe to real-time events.

```dart
final socket = HyperliquidSocket();
await socket.connect();

// Subscribe to data
socket.subscribeToL2Book('BTC');
socket.subscribeToTrades('ETH');
socket.subscribeToAllMids();

// Listen to the stream
socket.stream.listen((event) {
  print('New Event: $event');
});
```

## Development

### Code Generation

This project uses `json_serializable` for JSON serialization. If you modify any models in `lib/src/models/`, you must run the build runner to generate the necessary `.g.dart` files.

**Command to generate serializations:**

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Project Structure

- `lib/src/api/`: API implementation (Info, Exchange).
- `lib/src/models/`: Data models (Requests, Responses).
- `lib/src/utils/`: Utility classes (Signing, Hashing).
- `lib/src/client.dart`: Core HTTP client wrapper.

## Resources

- [Hyperliquid Official Docs](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api)
- [Hyperliquid TypeScript SDK](https://github.com/nktkas/hyperliquid)
