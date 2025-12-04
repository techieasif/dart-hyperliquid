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

    return _postAction(action, nonce);
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

    return _postAction(action, nonce);
  }

  /// Updates the leverage for a specific [coin].
  ///
  /// [isCross] specifies if the leverage is cross (true) or isolated (false).
  /// [leverage] is the new leverage value.
  Future<dynamic> updateLeverage(
      String coin, bool isCross, int leverage) async {
    final nonce = DateTime.now().millisecondsSinceEpoch;
    final action = {
      'type': 'updateLeverage',
      'asset': coin, // API expects 'asset' not 'coin' for this action
      'isCross': isCross,
      'leverage': leverage,
    };

    return _postAction(action, nonce);
  }

  /// Updates the isolated margin for a specific [coin].
  ///
  /// [isBuy] is true if adding margin, false if removing.
  /// [ntli] is the amount of margin to add/remove.
  Future<dynamic> updateIsolatedMargin(
      String coin, bool isBuy, double ntli) async {
    final nonce = DateTime.now().millisecondsSinceEpoch;
    final action = {
      'type': 'updateIsolatedMargin',
      'asset': coin, // API expects 'asset' not 'coin' for this action
      'isBuy': isBuy,
      'ntli': ntli,
    };

    return _postAction(action, nonce);
  }

  /// Sends USD to another address.
  ///
  /// [destination] is the recipient address.
  /// [amount] is the amount of USD to send.
  Future<dynamic> usdSend(String destination, double amount) async {
    final nonce = DateTime.now().millisecondsSinceEpoch;
    final action = {
      'hyperliquidChain': isMainnet ? 'Mainnet' : 'Testnet',
      'destination': destination,
      'amount': amount.toString(),
      'time': nonce,
    };

    return _postUserSignedAction(
      action,
      SigningUtils.usdSendTypes,
      'HyperliquidTransaction:UsdSend',
      nonce,
    );
  }

  /// Sends a spot token to another address.
  ///
  /// [destination] is the recipient address.
  /// [token] is the token identifier (e.g., "PURR:0xc4...").
  /// [amount] is the amount to send.
  Future<dynamic> spotSend(
      String destination, String token, double amount) async {
    final nonce = DateTime.now().millisecondsSinceEpoch;
    final action = {
      'hyperliquidChain': isMainnet ? 'Mainnet' : 'Testnet',
      'destination': destination,
      'token': token,
      'amount': amount.toString(),
      'time': nonce,
    };

    return _postUserSignedAction(
      action,
      SigningUtils.spotSendTypes,
      'HyperliquidTransaction:SpotSend',
      nonce,
    );
  }

  /// Withdraws funds to the L1 chain (Arbitrum).
  ///
  /// [destination] is the recipient address on L1.
  /// [amount] is the amount to withdraw.
  Future<dynamic> withdraw3(String destination, double amount) async {
    final nonce = DateTime.now().millisecondsSinceEpoch;
    final action = {
      'hyperliquidChain': isMainnet ? 'Mainnet' : 'Testnet',
      'destination': destination,
      'amount': amount.toString(),
      'time': nonce,
    };

    return _postUserSignedAction(
      action,
      SigningUtils.withdraw3Types,
      'HyperliquidTransaction:Withdraw',
      nonce,
    );
  }

  /// Creates a new sub-account.
  ///
  /// [name] is the name of the sub-account.
  Future<dynamic> createSubAccount(String name) async {
    final nonce = DateTime.now().millisecondsSinceEpoch;
    final action = {
      'hyperliquidChain': isMainnet ? 'Mainnet' : 'Testnet',
      'name': name,
      'nonce': nonce,
    };

    return _postUserSignedAction(
      action,
      SigningUtils.createSubAccountTypes,
      'HyperliquidTransaction:CreateSubAccount',
      nonce,
    );
  }

  /// Transfers funds between the main account and a sub-account.
  ///
  /// [subAccountUser] is the address of the sub-account.
  /// [isDeposit] is true if depositing to sub-account, false if withdrawing.
  /// [amount] is the amount to transfer (in USD).
  Future<dynamic> subAccountTransfer(
    String subAccountUser,
    bool isDeposit,
    double amount,
  ) async {
    final nonce = DateTime.now().millisecondsSinceEpoch;
    final action = {
      'hyperliquidChain': isMainnet ? 'Mainnet' : 'Testnet',
      'subAccountUser': subAccountUser,
      'isDeposit': isDeposit,
      'usd': amount.toString(),
      'nonce': nonce,
    };

    return _postUserSignedAction(
      action,
      SigningUtils.subAccountTransferTypes,
      'HyperliquidTransaction:SubAccountTransfer',
      nonce,
    );
  }

  /// Approves an agent to sign on behalf of the user.
  ///
  /// [agentAddress] is the address of the agent.
  /// [agentName] is an optional name for the agent.
  Future<dynamic> approveAgent(String agentAddress, String? agentName) async {
    final nonce = DateTime.now().millisecondsSinceEpoch;
    final action = {
      'hyperliquidChain': isMainnet ? 'Mainnet' : 'Testnet',
      'agentAddress': agentAddress,
      'agentName': agentName ?? '',
      'nonce': nonce,
    };

    return _postUserSignedAction(
      action,
      SigningUtils.approveAgentTypes,
      'HyperliquidTransaction:ApproveAgent',
      nonce,
    );
  }

  /// Helper method to sign and post an action.
  Future<dynamic> _postAction(Map<String, dynamic> action, int nonce) async {
    final signature = await SigningUtils.signL1Action(
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

  /// Helper method to sign and post a user-signed action.
  Future<dynamic> _postUserSignedAction(
    Map<String, dynamic> action,
    Map<String, List<Map<String, String>>> types,
    String primaryType,
    int nonce,
  ) async {
    final signature = await SigningUtils.signUserSignedAction(
      _wallet,
      action,
      types,
      primaryType,
      42161, // Arbitrum One Chain ID
    );

    final payload = {
      'action': {
        'type': _getActionType(primaryType),
        ...action,
      },
      'nonce': nonce,
      'signature': {
        'r': '0x${signature.r.toRadixString(16)}',
        's': '0x${signature.s.toRadixString(16)}',
        'v': signature.v,
      },
      'vaultAddress': null,
    };

    // For user signed actions, the action object in payload might need to be slightly different
    // The API expects the action fields directly, but with a 'type' field.
    // However, for signing, we used the struct.
    // Let's adjust the payload construction.

    // Actually, looking at the docs/examples, the payload for user signed actions
    // is just the action object + signature + nonce.
    // But the action object needs the 'type' field which matches the primary type (e.g. 'usdSend').

    return _client.post('/exchange', data: payload).then((r) => r.data);
  }

  String _getActionType(String primaryType) {
    switch (primaryType) {
      case 'HyperliquidTransaction:UsdSend':
        return 'usdSend';
      case 'HyperliquidTransaction:SpotSend':
        return 'spotSend';
      case 'HyperliquidTransaction:Withdraw':
        return 'withdraw3';
      case 'HyperliquidTransaction:ApproveAgent':
        return 'approveAgent';
      case 'HyperliquidTransaction:CreateSubAccount':
        return 'createSubAccount';
      case 'HyperliquidTransaction:SubAccountTransfer':
        return 'subAccountTransfer';
      default:
        throw Exception('Unknown primary type: $primaryType');
    }
  }
}
