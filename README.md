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
  hyperliquid_dart:
    path: . # Or git url
```

## Usage

### Initialization

```dart
import 'package:hyperliquid_dart/hyperliquid_dart.dart';

void main() {
  // Create the client
  final client = HyperliquidClient();
  
  // Initialize APIs
  final infoApi = InfoApi(client);
  
  // For authenticated requests (Exchange API)
  // final wallet = EthPrivateKey.fromHex('YOUR_PRIVATE_KEY');
  // final exchangeApi = ExchangeApi(client, wallet);
}
```

### Fetching Data (Info API)

```dart
// Get metadata (universe, margin tables)
final meta = await infoApi.getMeta();

// Get current mid prices
final mids = await infoApi.getAllMids();
print('BTC Price: ${mids['BTC']}');
```

### Placing Orders (Exchange API)

```dart
import 'package:web3dart/web3dart.dart';

// Initialize with your private key
final wallet = EthPrivateKey.fromHex('YOUR_PRIVATE_KEY');
final exchangeApi = ExchangeApi(client, wallet);

// Place a limit order
final result = await exchangeApi.placeOrders([
  OrderRequest(
    assetIndex: 0, // Asset index for BTC (check meta.universe)
    isBuy: true,   // Buy
    price: "30000",
    size: "0.01",
    reduceOnly: false,
    orderType: OrderType.limit(tif: 'Gtc'), // Good Til Cancelled
  )
]);
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
