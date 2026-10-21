import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/cache/json_cache.dart';
import 'package:mobile/core/formatting/freshness.dart';
import 'package:mobile/core/network/api_exception.dart';
import 'package:mobile/core/network/dio_provider.dart';
import 'package:mobile/features/market/data/models/financial_history.dart';
import 'package:mobile/features/market/data/models/financial_quote.dart';

final marketRepositoryProvider = Provider<MarketRepository>(
  (ref) => MarketRepository(dio: ref.watch(dioProvider), cache: ref.watch(jsonCacheProvider)),
);

class MarketRepository {
  final Dio dio;
  final JsonCache cache;
  final DateTime Function() now;

  MarketRepository({required this.dio, required this.cache, this.now = DateTime.now});

  Future<FinancialQuote> getQuote(String financialAssetId) async {
    final entry = await _load('quote:$financialAssetId', '/api/market/assets/$financialAssetId/quote');
    return FinancialQuote.fromJson(entry.json, fetchedAt: entry.fetchedAt);
  }

  Future<FinancialHistory> getHistory(String financialAssetId) async {
    final entry = await _load('history:$financialAssetId', '/api/market/assets/$financialAssetId/history');
    return FinancialHistory.fromJson(entry.json, fetchedAt: entry.fetchedAt);
  }

  Future<CachedJson> _load(String key, String path) async {
    final cached = await cache.read(key);
    if (cached != null && isSameDay(cached.fetchedAt.toLocal(), now().toLocal()))
      return cached;

    try {
      final response = await dio.get(path);
      final json = response.data as Map<String, dynamic>;
      final fetchedAt = now();
      await cache.write(key, json, fetchedAt);
      return CachedJson(json, fetchedAt);
    } on DioException catch (exception) {
      if (cached != null)
        return cached;
      throw exception.toApiException();
    }
  }
}
