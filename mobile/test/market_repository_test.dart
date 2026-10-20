import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/core/api/api_exception.dart';
import 'package:mobile/core/cache/json_cache.dart';
import 'package:mobile/features/market/repositories/market_repository.dart';

class _FakeApiClient implements ApiClient {
  int calls = 0;
  bool offline = false;
  double price = 100;

  @override
  Future<Map<String, dynamic>> getJson(String path) async {
    calls++;
    if (offline) throw const ApiException('Unable to reach the server.');
    return {
      'financialAssetId': 'a',
      'symbol': 'AAPL',
      'name': 'Apple',
      'assetType': 'STOCK',
      'price': price,
      'points': [],
    };
  }

  @override
  Future<List<dynamic>> getJsonList(String path) => throw UnimplementedError();
}

class _InMemoryJsonCache implements JsonCache {
  final entries = <String, CachedJson>{};

  @override
  Future<CachedJson?> read(String key) async => entries[key];

  @override
  Future<void> write(String key, Map<String, dynamic> json, DateTime fetchedAt) async {
    entries[key] = CachedJson(json, fetchedAt);
  }
}

void main() {
  late _FakeApiClient api;
  late _InMemoryJsonCache cache;
  late DateTime now;
  late OfflineFirstMarketRepository repository;

  setUp(() {
    api = _FakeApiClient();
    cache = _InMemoryJsonCache();
    now = DateTime(2026, 10, 20, 9);
    repository = OfflineFirstMarketRepository(api, cache, now: () => now);
  });

  test('fetches from the API and stores the response the first time', () async {
    final quote = await repository.getQuote('a');

    expect(api.calls, 1);
    expect(quote.price, 100);
    expect(quote.fetchedAt, now);
    expect(cache.entries.containsKey('quote:a'), isTrue);
  });

  test('serves the cached quote for the rest of the day', () async {
    await repository.getQuote('a');
    now = DateTime(2026, 10, 20, 23, 59);
    api.price = 200;

    final quote = await repository.getQuote('a');

    expect(api.calls, 1);
    expect(quote.price, 100);
  });

  test('fetches again the next day', () async {
    await repository.getQuote('a');
    now = DateTime(2026, 10, 21, 0, 1);
    api.price = 200;

    final quote = await repository.getQuote('a');

    expect(api.calls, 2);
    expect(quote.price, 200);
  });

  test('returns the last known quote when the server is unreachable', () async {
    await repository.getQuote('a');
    final firstFetch = now;
    now = DateTime(2026, 10, 22, 9);
    api.offline = true;

    final quote = await repository.getQuote('a');

    expect(quote.price, 100);
    expect(quote.fetchedAt, firstFetch);
  });

  test('fails when the server is unreachable and nothing is cached', () async {
    api.offline = true;

    await expectLater(repository.getQuote('a'), throwsA(isA<ApiException>()));
  });

  test('caches quote and history separately', () async {
    await repository.getQuote('a');
    await repository.getHistory('a');

    expect(api.calls, 2);
    expect(cache.entries.keys, containsAll(['quote:a', 'history:a']));
  });
}