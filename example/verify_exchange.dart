import 'package:hyperliquid_dart/hyperliquid_dart.dart';
import 'package:web3dart/web3dart.dart';
import 'dart:math';

void main() async {
  // Use a random private key for testing (DO NOT use real funds)
  final rng = Random.secure();
  final privateKey = EthPrivateKey.createRandom(rng);
  final client = HyperliquidClient();
  final exchangeApi = ExchangeApi(client, privateKey, isMainnet: true);

  print('Testing Exchange API payload construction (Dry Run)...');
  print('Wallet Address: ${privateKey.address.hex}');

  try {
    // We expect these to fail on the server side because the address has no funds/state,
    // but we want to verify that the SDK constructs the request without crashing.

    print('\n1. Update Leverage...');
    try {
      await exchangeApi.updateLeverage('BTC', true, 5);
    } catch (e) {
      print('Expected error (server side): $e');
    }

    print('\n2. Update Isolated Margin...');
    try {
      await exchangeApi.updateIsolatedMargin('BTC', true, 10.0);
    } catch (e) {
      print('Expected error (server side): $e');
    }

    print('\n3. USD Send...');
    try {
      await exchangeApi.usdSend(
          '0x0000000000000000000000000000000000000000', 1.0);
    } catch (e) {
      print('Expected error (server side): $e');
    }

    print('\n4. Create Sub-Account...');
    try {
      await exchangeApi.createSubAccount('test_sub');
    } catch (e) {
      print('Expected error (server side): $e');
    }

    print(
        'Dry run completed. If we see server errors instead of crash/type errors, the SDK is working.');
    print(
        'Note: usdSend, spotSend, etc. now use signUserSignedAction (EIP-712).');
  } catch (e) {
    print('Unexpected SDK Error: $e');
  }
}
