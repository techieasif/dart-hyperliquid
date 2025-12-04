import 'package:hyperliquid_dart/hyperliquid_dart.dart';

void main() async {
  final client = HyperliquidClient();
  final info = InfoApi(client);

  try {
    print('Fetching Meta...');
    final meta = await info.getMeta();
    print('Universe size: ${meta.universe.length}');
    print('First asset: ${meta.universe.first.name}');

    print('\nFetching Mids...');
    final mids = await info.getAllMids();
    print('BTC Price: ${mids['BTC']}');

    // Uncomment to test Exchange API (requires private key)
    /*
    final wallet = EthPrivateKey.fromHex('YOUR_PRIVATE_KEY');
    final exchange = ExchangeApi(client, wallet);
    // ...
    */
  } catch (e) {
    print('Error: $e');
  }
}
