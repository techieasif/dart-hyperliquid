import 'package:hyperliquid_dart/hyperliquid_dart.dart';

void main() async {
  final client = HyperliquidClient();
  final infoApi = InfoApi(client);

  try {
    print('Fetching Spot Meta...');
    final spotMeta = await infoApi.getSpotMeta();
    print('Spot Meta fetched successfully.');
    print('Universe count: ${spotMeta.universe.length}');
    print('Tokens count: ${spotMeta.tokens.length}');
    if (spotMeta.tokens.isNotEmpty) {
      print('First token: ${spotMeta.tokens[0].name}');
    }

    print('\nFetching Spot Clearinghouse State for 0x0...');
    final spotState = await infoApi.getSpotClearinghouseState(
        '0x0000000000000000000000000000000000000000');
    print('Spot Clearinghouse State fetched successfully.');
    print('Balances count: ${spotState.balances.length}');

    print('\nFetching Active Asset Data for 0x0 and BTC...');
    final activeAssetData = await infoApi.getActiveAssetData(
        '0x0000000000000000000000000000000000000000', 'BTC');
    print('Active Asset Data fetched successfully.');
    print('Mark Price: ${activeAssetData.markPx}');
  } catch (e) {
    print('Error: $e');
  }
}
