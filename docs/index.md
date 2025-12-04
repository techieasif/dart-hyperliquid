# Hyperliquid Dart SDK

A strongly-typed, comprehensive Dart SDK for the [Hyperliquid](https://hyperliquid.xyz) API.

[![Pub Version](https://img.shields.io/pub/v/hyperliquid_dart)](https://pub.dev/packages/hyperliquid_dart)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

- **Complete API Coverage**: Access all Info, Exchange, and WebSocket endpoints.
- **Strongly Typed**: All responses and events are parsed into Dart models (e.g., `L2Book`, `TradeEvent`).
- **EIP-712 Signing**: Built-in support for signing orders, transfers, and withdrawals using `web3dart`.
- **WebSocket Support**: Real-time data streaming with typed events.
- **Helper Utilities**: `SymbolConverter` for easy asset ID mapping.

## Quick Example

```dart
import 'package:hyperliquid_dart/hyperliquid_dart.dart';

void main() async {
  final client = HyperliquidClient();
  final api = InfoApi(client);

  // Fetch L2 Book
  final book = await api.getL2Book('BTC');
  print('BTC Price: ${book.levels[0].px}');
}
```
