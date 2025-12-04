import 'package:web3dart/web3dart.dart';
import '../client.dart';
import '../models/exchange/order_request.dart';
import '../utils/signing.dart';

/// Provides access to the Hyperliquid Exchange API.
///
/// The Exchange API is used for authenticated actions such as placing orders,
/// canceling orders, and transfers. All requests are signed using EIP-712.
///
/// See also: [Hyperliquid Exchange API Docs](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/exchange-endpoint)
class ExchangeApi {
  final HyperliquidClient _client;
  final Credentials _wallet;
  final bool isMainnet;

  /// Creates a new [ExchangeApi] instance.
  ///
  /// [_client] is the HTTP client.
  /// [_wallet] is the credentials (private key) used for signing requests.
  /// [isMainnet] determines whether to sign for Mainnet or Testnet (defaults to true).
  ExchangeApi(
    this._client,
    this._wallet, {
    this.isMainnet = true,
  });

  /// Places one or more orders.
  ///
  /// [orders] is a list of [OrderRequest] objects defining the orders to place.
  /// [grouping] specifies the order grouping strategy (default: 'na').
  ///
  /// This method constructs the order action, signs it using EIP-712, and sends it to the exchange.
  Future<dynamic> placeOrders(
    List<OrderRequest> orders, {
    String grouping = 'na',
  }) async {
    final nonce = DateTime.now().millisecondsSinceEpoch;
    final action = {
      'type': 'order',
      'orders': orders.map((o) => o.toJson()).toList(),
      'grouping': grouping,
    };

    final signature = SigningUtils.signL1Action(
      _wallet,
      action,
      null,
      nonce,
      isMainnet,
    );

    final payload = {
      'action': action,
      'nonce': nonce,
      'signature': {
        'r': '0x${signature.r.toRadixString(16)}',
        's': '0x${signature.s.toRadixString(16)}',
        'v': signature.v,
      },
      'vaultAddress': null,
    };

    final response = await _client.post('/exchange', data: payload);
    return response.data;
  }

  /// Cancels a specific order.
  ///
  /// [coin] is the asset symbol (e.g., "BTC").
  /// [oid] is the order ID to cancel.
  Future<dynamic> cancelOrder(String coin, int oid) async {
    final nonce = DateTime.now().millisecondsSinceEpoch;
    final action = {
      'type': 'cancel',
      'cancels': [
        {'coin': coin, 'oid': oid}
      ],
    };

    final signature = SigningUtils.signL1Action(
      _wallet,
      action,
      null,
      nonce,
      isMainnet,
    );

    final payload = {
      'action': action,
      'nonce': nonce,
      'signature': {
        'r': '0x${signature.r.toRadixString(16)}',
        's': '0x${signature.s.toRadixString(16)}',
        'v': signature.v,
      },
      'vaultAddress': null,
    };

    final response = await _client.post('/exchange', data: payload);
    return response.data;
  }
}
