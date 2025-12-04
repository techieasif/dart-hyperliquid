import 'package:hyperliquid_dart/hyperliquid_dart.dart';

void main() async {
  final client = HyperliquidClient();
  final infoApi = InfoApi(client);

  try {
    print('Fetching L2 Book for BTC...');
    final l2Book = await infoApi.getL2Book('BTC');
    print('L2 Book fetched successfully.');
    print('Coin: ${l2Book.coin}');
    print('Time: ${l2Book.time}');
    print('Levels count: ${l2Book.levels.length}');
    if (l2Book.levels.isNotEmpty) {
      print('First level bids count: ${l2Book.levels[0].length}');
    }

    print('\nFetching User State for 0x0...');
    final userState = await infoApi
        .getUserState('0x0000000000000000000000000000000000000000');
    print('User State fetched successfully.');
    print('Account Value: ${userState.marginSummary.accountValue}');

    print('\nFetching Open Orders for 0x0...');
    final openOrders = await infoApi
        .getOpenOrders('0x0000000000000000000000000000000000000000');
    print('Open Orders fetched successfully.');
    print('Open Orders count: ${openOrders.length}');
  } catch (e) {
    print('Error: $e');
  }
}
