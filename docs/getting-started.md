# Getting Started

## Installation

Add `hyperliquid_dart` to your `pubspec.yaml`:

```yaml
dependencies:
  hyperliquid_dart: ^0.1.0
```

Or run:

```bash
dart pub add hyperliquid_dart
```

## Basic Usage

### Initialization

The SDK is split into three main components: `InfoApi`, `ExchangeApi`, and `HyperliquidSocket`.

```dart
import 'package:hyperliquid_dart/hyperliquid_dart.dart';
import 'package:web3dart/web3dart.dart';

// 1. Create a client (handles HTTP requests)
final client = HyperliquidClient(isMainnet: true); // Defaults to true

// 2. Initialize APIs
final infoApi = InfoApi(client);
final socket = HyperliquidSocket(); // Defaults to Mainnet URL

// 3. For Exchange API, you need a wallet
final privateKey = 'YOUR_PRIVATE_KEY_HEX';
final wallet = EthPrivateKey.fromHex(privateKey);
final exchangeApi = ExchangeApi(client, wallet, isMainnet: true);
```

### Environment

You can switch between Mainnet and Testnet:

```dart
// Mainnet (Default)
final client = HyperliquidClient(baseUrl: 'https://api.hyperliquid.xyz');

// Testnet
final client = HyperliquidClient(baseUrl: 'https://api.hyperliquid-testnet.xyz');
```
