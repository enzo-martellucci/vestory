import '../../../core/api/api_client.dart';
import '../models/financial_history.dart';
import '../models/financial_quote.dart';

abstract interface class MarketRepository {
  Future<FinancialQuote> getQuote(String financialAssetId);

  Future<FinancialHistory> getHistory(String financialAssetId);
}

class ApiMarketRepository implements MarketRepository {
  final ApiClient _api;

  const ApiMarketRepository(this._api);

  @override
  Future<FinancialQuote> getQuote(String financialAssetId) async {
    final json =
        await _api.getJson('/api/market/assets/$financialAssetId/quote');
    return FinancialQuote.fromJson(json);
  }

  @override
  Future<FinancialHistory> getHistory(String financialAssetId) async {
    final json =
        await _api.getJson('/api/market/assets/$financialAssetId/history');
    return FinancialHistory.fromJson(json);
  }
}

class CachedMarketRepository implements MarketRepository {
  final MarketRepository _inner;
  final Duration quoteTtl;
  final Duration historyTtl;
  final DateTime Function() _now;

  final _quotes = <String, _CacheEntry<FinancialQuote>>{};
  final _histories = <String, _CacheEntry<FinancialHistory>>{};

  CachedMarketRepository(
    this._inner, {
    this.quoteTtl = const Duration(minutes: 1),
    this.historyTtl = const Duration(minutes: 15),
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  @override
  Future<FinancialQuote> getQuote(String financialAssetId) => _cached(
        _quotes,
        financialAssetId,
        quoteTtl,
        () => _inner.getQuote(financialAssetId),
      );

  @override
  Future<FinancialHistory> getHistory(String financialAssetId) => _cached(
        _histories,
        financialAssetId,
        historyTtl,
        () => _inner.getHistory(financialAssetId),
      );

  void clear() {
    _quotes.clear();
    _histories.clear();
  }

  Future<T> _cached<T>(
    Map<String, _CacheEntry<T>> cache,
    String key,
    Duration ttl,
    Future<T> Function() fetch,
  ) {
    final entry = cache[key];
    if (entry != null && _now().difference(entry.createdAt) < ttl) {
      return entry.future;
    }

    final future = fetch();
    cache[key] = _CacheEntry(future, _now());

    // Ne pas garder un échec en cache.
    // (Le `future` d'origine, renvoyé à l'appelant, garde son erreur.)
    future.then<void>(
      (_) {},
      onError: (Object _) {
        if (identical(cache[key]?.future, future)) cache.remove(key);
      },
    );

    return future;
  }
}

class _CacheEntry<T> {
  final Future<T> future;
  final DateTime createdAt;

  const _CacheEntry(this.future, this.createdAt);
}
