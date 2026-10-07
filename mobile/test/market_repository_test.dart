import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/market/models/financial_history.dart';
import 'package:mobile/features/market/models/financial_quote.dart';
import 'package:mobile/features/market/repositories/market_repository.dart';

class _CountingRepository implements MarketRepository {
  int quoteCalls = 0;
  bool fail = false;

  @override
  Future<FinancialQuote> getQuote(String id) async {
    quoteCalls++;
    if (fail) throw Exception('boom');
    return FinancialQuote(
      financialAssetId: id,
      symbol: 'X',
      name: 'X',
      assetType: 'STOCK',
      price: 1,
    );
  }

  @override
  Future<FinancialHistory> getHistory(String id) async =>
      FinancialHistory(financialAssetId: id, symbol: 'X', points: const []);
}

void main() {
  late _CountingRepository inner;
  late DateTime now;
  late CachedMarketRepository repo;

  setUp(() {
    inner = _CountingRepository();
    now = DateTime(2026, 1, 1);
    repo = CachedMarketRepository(inner, now: () => now);
  });

  test('sert la cotation depuis le cache pendant le TTL', () async {
    await repo.getQuote('a');
    await repo.getQuote('a');
    expect(inner.quoteCalls, 1);
  });

  test('recharge après expiration du TTL', () async {
    await repo.getQuote('a');
    now = now.add(const Duration(minutes: 2));
    await repo.getQuote('a');
    expect(inner.quoteCalls, 2);
  });

  test('dédoublonne les requêtes simultanées', () async {
    await Future.wait([repo.getQuote('a'), repo.getQuote('a')]);
    expect(inner.quoteCalls, 1);
  });

  test("ne met pas d'erreur en cache", () async {
    inner.fail = true;
    await expectLater(repo.getQuote('a'), throwsException);
    inner.fail = false;
    await repo.getQuote('a');
    expect(inner.quoteCalls, 2);
  });
}
