import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:msgpack_dart/msgpack_dart.dart';
import 'package:pointycastle/digests/keccak.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';

/// Utility class for cryptographic operations required by Hyperliquid.
///
/// This includes Keccak-256 hashing, address conversion, action hashing (using msgpack),
/// and EIP-712 structured data signing.
///
/// See also: [Hyperliquid Signing Docs](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/signing)
class SigningUtils {
  /// Computes the Keccak-256 hash of the [input].
  static Uint8List keccak256(Uint8List input) {
    final digest = KeccakDigest(256);
    return digest.process(input);
  }

  /// Converts a hex address string to bytes.
  static Uint8List addressToBytes(String address) {
    final clean = address.toLowerCase().replaceAll('0x', '');
    return Uint8List.fromList(hex.decode(clean));
  }

  /// Computes the action hash for a given [action].
  ///
  /// The action hash is constructed by serializing the action using msgpack,
  /// appending the nonce and vault address, and then hashing the result.
  static Uint8List actionHash(
    Map<String, dynamic> action,
    String? vaultAddress,
    int nonce,
  ) {
    final packed = serialize(action);

    final nonceBytes = Uint8List(8);
    ByteData.view(nonceBytes.buffer).setUint64(0, nonce, Endian.big);

    final builder = BytesBuilder();
    builder.add(packed);
    builder.add(nonceBytes);

    if (vaultAddress == null) {
      builder.addByte(0);
    } else {
      builder.addByte(1);
      builder.add(addressToBytes(vaultAddress));
    }

    return keccak256(builder.toBytes());
  }

  /// Constructs the "Phantom Agent" structure used for L1 signing.
  static Map<String, dynamic> constructPhantomAgent(
      Uint8List hash, bool isMainnet) {
    return {
      'source': isMainnet ? 'a' : 'b',
      'connectionId': hash,
    };
  }

  // --- EIP-712 Implementation ---

  /// Hashes a struct according to EIP-712.
  static Uint8List hashStruct(
    String primaryType,
    Map<String, dynamic> data,
    Map<String, List<Map<String, String>>> types,
  ) {
    final typeHash = keccak256(
        Uint8List.fromList(utf8.encode(encodeType(primaryType, types))));
    final encodedData = encodeData(primaryType, data, types);

    final builder = BytesBuilder();
    builder.add(typeHash);
    builder.add(encodedData);

    return keccak256(builder.toBytes());
  }

  /// Encodes the type definition string for EIP-712.
  static String encodeType(
      String primaryType, Map<String, List<Map<String, String>>> types) {
    if (primaryType == 'Agent') {
      return 'Agent(string source,bytes32 connectionId)';
    } else if (primaryType == 'EIP712Domain') {
      return 'EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)';
    } else if (primaryType == 'HyperliquidTransaction:UsdSend') {
      return 'HyperliquidTransaction:UsdSend(string hyperliquidChain,string destination,string amount,uint64 time)';
    } else if (primaryType == 'HyperliquidTransaction:SpotSend') {
      return 'HyperliquidTransaction:SpotSend(string hyperliquidChain,string destination,string token,string amount,uint64 time)';
    } else if (primaryType == 'HyperliquidTransaction:Withdraw') {
      return 'HyperliquidTransaction:Withdraw(string hyperliquidChain,string destination,string amount,uint64 time)';
    } else if (primaryType == 'HyperliquidTransaction:ApproveAgent') {
      return 'HyperliquidTransaction:ApproveAgent(string hyperliquidChain,address agentAddress,string agentName,uint64 nonce)';
    } else if (primaryType == 'HyperliquidTransaction:CreateSubAccount') {
      return 'HyperliquidTransaction:CreateSubAccount(string hyperliquidChain,string name,uint64 nonce)';
    } else if (primaryType == 'HyperliquidTransaction:SubAccountTransfer') {
      return 'HyperliquidTransaction:SubAccountTransfer(string hyperliquidChain,address subAccountUser,bool isDeposit,string usd,uint64 nonce)';
    }
    throw UnimplementedError('Type $primaryType not implemented');
  }

  /// Encodes the data fields for EIP-712.
  static Uint8List encodeData(
    String primaryType,
    Map<String, dynamic> data,
    Map<String, List<Map<String, String>>> types,
  ) {
    final fields = types[primaryType]!;
    final builder = BytesBuilder();

    for (final field in fields) {
      final value = data[field['name']];
      final type = field['type']!;

      if (type == 'string') {
        builder
            .add(keccak256(Uint8List.fromList(utf8.encode(value as String))));
      } else if (type == 'bytes32') {
        if (value is Uint8List) {
          if (value.length != 32) throw Exception('bytes32 must be 32 bytes');
          builder.add(value);
        } else if (value is String) {
          final bytes = hex.decode(value.replaceAll('0x', ''));
          if (bytes.length != 32) throw Exception('bytes32 must be 32 bytes');
          builder.add(Uint8List.fromList(bytes));
        }
      } else if (type == 'uint256') {
        final bigInt = value is BigInt ? value : BigInt.from(value as int);
        final bytes = bigIntToBytes(bigInt);
        builder.add(padLeft(bytes, 32));
      } else if (type == 'address') {
        final bytes = addressToBytes(value as String);
        builder.add(padLeft(bytes, 32));
      }
    }
    return builder.toBytes();
  }

  static Uint8List bigIntToBytes(BigInt number) {
    var hexString = number.toRadixString(16);
    if (hexString.length % 2 != 0) hexString = '0$hexString';
    return Uint8List.fromList(hex.decode(hexString));
  }

  static Uint8List padLeft(Uint8List list, int length) {
    if (list.length >= length) return list;
    final result = Uint8List(length);
    result.setRange(length - list.length, length, list);
    return result;
  }

  /// Signs an L1 action using the provided [wallet].
  ///
  /// This involves:
  /// 1. Calculating the action hash.
  /// 2. Constructing a phantom agent.
  /// 3. Creating the EIP-712 domain and message.
  /// 4. Signing the EIP-712 hash.
  static Future<MsgSignature> signL1Action(
    Credentials wallet,
    Map<String, dynamic> action,
    String? vaultAddress,
    int nonce,
    bool isMainnet,
  ) async {
    final hash = actionHash(action, vaultAddress, nonce);
    final phantomAgent = constructPhantomAgent(hash, isMainnet);

    final domain = {
      'name': 'Exchange',
      'version': '1',
      'chainId': 1337,
      'verifyingContract': '0x0000000000000000000000000000000000000000',
    };

    final types = {
      'EIP712Domain': [
        {'name': 'name', 'type': 'string'},
        {'name': 'version', 'type': 'string'},
        {'name': 'chainId', 'type': 'uint256'},
        {'name': 'verifyingContract', 'type': 'address'},
      ],
      'Agent': [
        {'name': 'source', 'type': 'string'},
        {'name': 'connectionId', 'type': 'bytes32'},
      ],
    };

    final domainSeparator = hashStruct('EIP712Domain', domain, types);
    final messageHash = hashStruct('Agent', phantomAgent, types);

    final builder = BytesBuilder();
    builder.add(Uint8List.fromList([0x19, 0x01]));
    builder.add(domainSeparator);
    builder.add(messageHash);

    final digest = keccak256(builder.toBytes());

    return wallet.signToSignature(digest, chainId: isMainnet ? 42161 : 421614);
  }

  /// Signs a user-signed action (e.g., transfers, withdrawals).
  ///
  /// [types] should contain the EIP-712 type definitions.
  /// [primaryType] is the name of the primary type (e.g., "UsdSend").
  static Future<MsgSignature> signUserSignedAction(
    Credentials wallet,
    Map<String, dynamic> action,
    Map<String, List<Map<String, String>>> types,
    String primaryType,
    int chainId,
  ) async {
    final domain = {
      'name': 'HyperliquidSignTransaction',
      'version': '1',
      'chainId': chainId,
      'verifyingContract': '0x0000000000000000000000000000000000000000',
    };

    // Merge domain types with action types
    final allTypes = {
      'EIP712Domain': [
        {'name': 'name', 'type': 'string'},
        {'name': 'version', 'type': 'string'},
        {'name': 'chainId', 'type': 'uint256'},
        {'name': 'verifyingContract', 'type': 'address'},
      ],
      ...types,
    };

    final domainSeparator = hashStruct('EIP712Domain', domain, allTypes);
    final messageHash = hashStruct(primaryType, action, allTypes);

    final builder = BytesBuilder();
    builder.add(Uint8List.fromList([0x19, 0x01]));
    builder.add(domainSeparator);
    builder.add(messageHash);

    final digest = keccak256(builder.toBytes());

    return wallet.signToSignature(digest, chainId: chainId);
  }

  // --- EIP-712 Type Definitions ---

  static const Map<String, List<Map<String, String>>> usdSendTypes = {
    'HyperliquidTransaction:UsdSend': [
      {'name': 'hyperliquidChain', 'type': 'string'},
      {'name': 'destination', 'type': 'string'},
      {'name': 'amount', 'type': 'string'},
      {'name': 'time', 'type': 'uint64'},
    ],
  };

  static const Map<String, List<Map<String, String>>> spotSendTypes = {
    'HyperliquidTransaction:SpotSend': [
      {'name': 'hyperliquidChain', 'type': 'string'},
      {'name': 'destination', 'type': 'string'},
      {'name': 'token', 'type': 'string'},
      {'name': 'amount', 'type': 'string'},
      {'name': 'time', 'type': 'uint64'},
    ],
  };

  static const Map<String, List<Map<String, String>>> withdraw3Types = {
    'HyperliquidTransaction:Withdraw': [
      {'name': 'hyperliquidChain', 'type': 'string'},
      {'name': 'destination', 'type': 'string'},
      {'name': 'amount', 'type': 'string'},
      {'name': 'time', 'type': 'uint64'},
    ],
  };

  static const Map<String, List<Map<String, String>>> approveAgentTypes = {
    'HyperliquidTransaction:ApproveAgent': [
      {'name': 'hyperliquidChain', 'type': 'string'},
      {'name': 'agentAddress', 'type': 'address'},
      {'name': 'agentName', 'type': 'string'},
      {'name': 'nonce', 'type': 'uint64'},
    ],
  };

  static const Map<String, List<Map<String, String>>> createSubAccountTypes = {
    'HyperliquidTransaction:CreateSubAccount': [
      {'name': 'hyperliquidChain', 'type': 'string'},
      {'name': 'name', 'type': 'string'},
      {'name': 'nonce', 'type': 'uint64'},
    ],
  };

  static const Map<String, List<Map<String, String>>> subAccountTransferTypes =
      {
    'HyperliquidTransaction:SubAccountTransfer': [
      {'name': 'hyperliquidChain', 'type': 'string'},
      {'name': 'subAccountUser', 'type': 'address'},
      {'name': 'isDeposit', 'type': 'bool'},
      {'name': 'usd', 'type': 'string'},
      {'name': 'nonce', 'type': 'uint64'},
    ],
  };
}
