import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/cache/json_cache.dart';
import '../models/financial_history.dart';
import '../models/financial_quote.dart';

abstract interface class MarketRepository {
  Future<FinancialQuote> getQuote(String financialAssetId);

  Future<FinancialHistory> getHistory(String financialAssetId);
}

class OfflineFirstMarketRepository implements MarketRepository {
  final ApiClient _api;
  final JsonCache _cache;
  final DateTime Function() _now;

  OfflineFirstMarketRepository(this._api, this._cache, {DateTime Function()? now})
      : _now = now ?? DateTime.now;

  @override
  Future<FinancialQuote> getQuote(String financialAssetId) async {
    final entry = await _load(
      'quote:$financialAssetId',
      '/api/market/assets/$financialAssetId/quote',
    );
    return FinancialQuote.fromJson(entry.json, fetchedAt: entry.fetchedAt);
  }

  @override
  Future<FinancialHistory> getHistory(String financialAssetId) async {
    final entry = await _load(
      'history:$financialAssetId',
      '/api/market/assets/$financialAssetId/history',
    );
    return FinancialHistory.fromJson(entry.json, fetchedAt: entry.fetchedAt);
  }

  Future<CachedJson> _load(String key, String path) async {
    final cached = await _cache.read(key);
    if (cached != null && _isToday(cached.fetchedAt)) return cached;

    try {
      final json = await _api.getJson(path);
      final fetchedAt = _now();
      await _cache.write(key, json, fetchedAt);
      return CachedJson(json, fetchedAt);
    } on ApiException {
      if (cached != null) return cached;
      rethrow;
    }
  }

  bool _isToday(DateTime date) {
    final now = _now().toLocal();
    final local = date.toLocal();
    return local.year == now.year && local.month == now.month && local.day == now.day;
  }
}