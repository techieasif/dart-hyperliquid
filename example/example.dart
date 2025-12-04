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

    print('\nFetching L2 Book for BTC...');
    final l2Book = await info.getL2Book('BTC');
    if (l2Book.levels.isNotEmpty && l2Book.levels[0].isNotEmpty) {
      print('Best Bid: ${l2Book.levels[0][0].px}');
    }

    // WebSocket Example
    print('\nConnecting to WebSocket...');
    final socket = HyperliquidSocket();
    await socket.connect();

    print('Subscribing to L2 Book for BTC...');
    socket.subscribeToL2Book('BTC');

    final subscription = socket.stream.listen((event) {
      if (event is L2BookEvent) {
        print('Received L2 Book update');
      }
    });

    // Wait a bit to receive events
    await Future.delayed(Duration(seconds: 3));
    await subscription.cancel();
    await socket.close();

    // Uncomment to test Exchange API (requires private key)
    /*
    final wallet = EthPrivateKey.fromHex('YOUR_PRIVATE_KEY');
    final exchange = ExchangeApi(client, wallet);
    await exchange.updateLeverage('BTC', true, 20);
    */
  } catch (e) {
    print('Error: $e');
  }
}
