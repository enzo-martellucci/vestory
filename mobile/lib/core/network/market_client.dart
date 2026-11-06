import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_cache_drift_store/http_cache_drift_store.dart';

const _twelveDataApiKey = String.fromEnvironment('TWELVE_DATA_API_KEY');

final cacheDirectoryProvider = Provider<String>((ref) => throw UnimplementedError('Cache directory not provided'));

final marketClientProvider = Provider<MarketClient>((ref) {
  final client = MarketClient.create(ref.watch(cacheDirectoryProvider));
  ref.onDispose(client.close);
  return client;
});

class MarketClient {
  final Dio dio;
  final CacheOptions cacheOptions;

  const MarketClient(this.dio, this.cacheOptions);

  factory MarketClient.create(String cacheDirectory) {
    final cacheOptions = CacheOptions(
      store: DriftCacheStore(databasePath: cacheDirectory, databaseName: 'market_cache'),
      policy: CachePolicy.forceCache,
      hitCacheOnNetworkFailure: true,
      maxStale: const Duration(days: 3650),
    );
    final dio = Dio(BaseOptions(
      baseUrl: 'https://api.twelvedata.com',
      queryParameters: {'apikey': _twelveDataApiKey},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
    ))..interceptors.add(DioCacheInterceptor(options: cacheOptions));
    return MarketClient(dio, cacheOptions);
  }

  Future<void> close() async {
    dio.close();
    await cacheOptions.store!.close();
  }
}

class MarketException implements Exception {
  final String message;

  const MarketException(this.message);

  factory MarketException.from(DioException exception) => switch (exception) {
    DioException(type: DioExceptionType.connectionError || DioExceptionType.connectionTimeout || DioExceptionType.receiveTimeout) =>
      const MarketException('No connection. Market data will load once you are back online.'),
    DioException(response: Response(statusCode: 429)) => const MarketException('Too many requests right now. Try again in a minute.'),
    DioException(response: Response(statusCode: 401)) => const MarketException('The market API key is missing or invalid.'),
    _ => const MarketException('Market data is unavailable for this asset.'),
  };

  @override
  String toString() => message;
}
