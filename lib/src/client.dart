import 'package:dio/dio.dart';

/// A client wrapper for interacting with the Hyperliquid API.
///
/// This class handles the base URL configuration and default headers for all requests.
/// It uses [Dio] for making HTTP requests.
class HyperliquidClient {
  final Dio _dio;
  final String baseUrl;

  /// Creates a new [HyperliquidClient].
  ///
  /// [baseUrl] defaults to the Hyperliquid Mainnet API URL: `https://api.hyperliquid.xyz`.
  /// [dio] can be provided to use a custom Dio instance.
  HyperliquidClient({
    String? baseUrl,
    Dio? dio,
  })  : baseUrl = baseUrl ?? 'https://api.hyperliquid.xyz',
        _dio = dio ?? Dio() {
    _dio.options.baseUrl = this.baseUrl;
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  /// Performs a POST request to the specified [path].
  ///
  /// [data] is the JSON body of the request.
  Future<Response<T>> post<T>(String path, {Object? data}) {
    return _dio.post<T>(path, data: data);
  }
}
