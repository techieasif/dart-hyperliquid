import '../client.dart';
import '../models/info/meta.dart';
import '../models/info/l2_book.dart';
import '../models/info/open_order.dart';
import '../models/info/clearinghouse_state.dart';
import '../models/info/spot_meta.dart';
import '../models/info/spot_clearinghouse_state.dart';
import '../models/info/active_asset_data.dart';

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
  Future<ClearinghouseState> getUserState(String user) async {
    final response = await _client.post('/info', data: {
      'type': 'clearinghouseState',
      'user': user,
    });
    return ClearinghouseState.fromJson(response.data);
  }

  /// Retrieves the open orders for a specific [user].
  ///
  /// Corresponds to `{"type": "openOrders", "user": "..."}`.
  Future<List<OpenOrder>> getOpenOrders(String user) async {
    final response = await _client.post('/info', data: {
      'type': 'openOrders',
      'user': user,
    });
    return (response.data as List).map((e) => OpenOrder.fromJson(e)).toList();
  }

  /// Retrieves the L2 order book for a specific [coin].
  ///
  /// [nSigFigs] is the number of significant figures (default 5).
  /// [mantissa] is the mantissa for aggregation (default null).
  /// Corresponds to `{"type": "l2Book", "coin": "...", "nSigFigs": ...}`.
  Future<L2Book> getL2Book(String coin, {int? nSigFigs, int? mantissa}) async {
    final response = await _client.post('/info', data: {
      'type': 'l2Book',
      'coin': coin,
      if (nSigFigs != null) 'nSigFigs': nSigFigs,
      if (mantissa != null) 'mantissa': mantissa,
    });
    return L2Book.fromJson(response.data);
  }

  /// Retrieves the spot metadata.
  ///
  /// Corresponds to `{"type": "spotMeta"}`.
  Future<SpotMeta> getSpotMeta() async {
    final response = await _client.post('/info', data: {'type': 'spotMeta'});
    return SpotMeta.fromJson(response.data);
  }

  /// Retrieves the spot clearinghouse state for a specific [user].
  ///
  /// Corresponds to `{"type": "spotClearinghouseState", "user": "..."}`.
  Future<SpotClearinghouseState> getSpotClearinghouseState(String user) async {
    final response = await _client.post('/info', data: {
      'type': 'spotClearinghouseState',
      'user': user,
    });
    return SpotClearinghouseState.fromJson(response.data);
  }

  /// Retrieves the active asset data for a specific [user] and [coin].
  ///
  /// Corresponds to `{"type": "activeAssetData", "user": "...", "coin": "..."}`.
  Future<ActiveAssetData> getActiveAssetData(String user, String coin) async {
    final response = await _client.post('/info', data: {
      'type': 'activeAssetData',
      'user': user,
      'coin': coin,
    });
    return ActiveAssetData.fromJson(response.data);
  }
}
