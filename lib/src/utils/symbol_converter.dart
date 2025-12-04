import '../api/info.dart';
import '../models/info/meta.dart';
import '../models/info/spot_meta.dart';

/// Helper class to convert between asset symbols and IDs.
class HyperliquidSymbolConverter {
  final InfoApi _infoApi;
  Meta? _meta;
  SpotMeta? _spotMeta;

  final Map<String, int> _perpSymbolToId = {};
  final Map<String, int> _spotSymbolToId = {};
  final Map<String, int> _perpDecimals = {};
  final Map<String, int> _spotDecimals = {};

  HyperliquidSymbolConverter(this._infoApi);

  /// Fetches metadata and builds the symbol mappings.
  Future<void> reload() async {
    _meta = await _infoApi.getMeta();
    _spotMeta = await _infoApi.getSpotMeta();

    _perpSymbolToId.clear();
    _perpDecimals.clear();
    for (var i = 0; i < _meta!.universe.length; i++) {
      final asset = _meta!.universe[i];
      _perpSymbolToId[asset.name] = i;
      _perpDecimals[asset.name] = asset.szDecimals;
    }

    _spotSymbolToId.clear();
    _spotDecimals.clear();
    for (final token in _spotMeta!.tokens) {
      final name = '${token.name}/USDC'; // Assuming USDC quote for now
      // Note: Spot ID logic is complex (token ID vs pair ID).
      // For simplicity, we map token name to index if canonical.
      // Ideally we need the universe to map pair -> ID.
    }

    // Better Spot Mapping using Universe
    for (final universeItem in _spotMeta!.universe) {
      final name = universeItem.name;
      _spotSymbolToId[name] = universeItem.index;

      // Find decimals from tokens list
      // This is a simplification; real logic might need more robust matching
      final token = _spotMeta!.tokens.firstWhere(
          (t) => t.index == universeItem.tokens[0],
          orElse: () => _spotMeta!.tokens[0] // Fallback
          );
      _spotDecimals[name] = token.szDecimals;
    }
  }

  /// Returns the asset ID for a given [symbol].
  ///
  /// Returns null if not found.
  int? getAssetId(String symbol) {
    if (_perpSymbolToId.containsKey(symbol)) {
      return _perpSymbolToId[symbol];
    }
    if (_spotSymbolToId.containsKey(symbol)) {
      return _spotSymbolToId[symbol];
    }
    return null;
  }

  /// Returns the size decimals for a given [symbol].
  int getSzDecimals(String symbol) {
    if (_perpDecimals.containsKey(symbol)) {
      return _perpDecimals[symbol]!;
    }
    if (_spotDecimals.containsKey(symbol)) {
      return _spotDecimals[symbol]!;
    }
    return 0; // Default
  }
}
