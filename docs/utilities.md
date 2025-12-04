# Utilities

## Symbol Converter

The `HyperliquidSymbolConverter` helps map human-readable symbols (like "BTC") to the internal Asset IDs required by some API responses or logic.

### Usage

```dart
final converter = HyperliquidSymbolConverter(infoApi);

// Load metadata first
await converter.reload();

// Get Asset ID
final btcId = converter.getAssetId('BTC'); // Returns int (e.g., 4)

// Get Size Decimals
final decimals = converter.getSzDecimals('ETH'); // Returns int (e.g., 3)
```

## Signing Utils

The `SigningUtils` class handles the complex EIP-712 signing logic required for the Exchange API.

> **Note**: You typically don't need to use this directly if you use `ExchangeApi`, but it's available for custom implementations.

```dart
import 'package:hyperliquid_dart/src/utils/signing.dart';

// Sign a custom action
final signature = await SigningUtils.signUserSignedAction(
  wallet,
  actionMap,
  typeDefinitions,
  'PrimaryType',
  42161, // Chain ID
);
```
