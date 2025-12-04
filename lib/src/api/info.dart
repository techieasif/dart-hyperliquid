import '../client.dart';
import '../models/info/meta.dart';

/// Provides access to the Hyperliquid Info API.
///
/// The Info API is used to retrieve public data such as metadata, asset prices,
/// user state, and open orders.
///
/// See also: [Hyperliquid Info API Docs](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint)
class InfoApi {
  final HyperliquidClient _client;

  InfoApi(this._client);

  /// Retrieves the exchange metadata, including the universe of assets and margin tables.
  ///
  /// Corresponds to `{"type": "meta"}`.
  Future<Meta> getMeta() async {
    final response = await _client.post('/info', data: {'type': 'meta'});
    return Meta.fromJson(response.data);
  }

  /// Retrieves the current mid prices for all assets in the universe.
  ///
  /// Returns a map where keys are asset names (e.g., "BTC") and values are prices as doubles.
  /// Corresponds to `{"type": "allMids"}`.
  Future<Map<String, double>> getAllMids() async {
    final response = await _client.post('/info', data: {'type': 'allMids'});
    final Map<String, dynamic> data = response.data;
    return data.map((key, value) => MapEntry(key, double.parse(value)));
  }

  /// Retrieves the clearinghouse state for a specific [user].
  ///
  /// This includes account value, margin summary, and asset positions.
  /// Corresponds to `{"type": "clearinghouseState", "user": "..."}`.
  Future<Map<String, dynamic>> getUserState(String user) async {
    final response = await _client.post('/info', data: {
      'type': 'clearinghouseState',
      'user': user,
    });
    return response.data;
  }

  /// Retrieves the open orders for a specific [user].
  ///
  /// Corresponds to `{"type": "openOrders", "user": "..."}`.
  Future<List<dynamic>> getOpenOrders(String user) async {
    final response = await _client.post('/info', data: {
      'type': 'openOrders',
      'user': user,
    });
    return response.data;
  }
}
