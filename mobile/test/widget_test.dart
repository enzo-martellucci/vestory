import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/app_dependencies.dart';
import 'package:mobile/app/vestory_app.dart';
import 'package:mobile/core/api/api_exception.dart';
import 'package:mobile/features/cards/models/asset_card_model.dart';
import 'package:mobile/features/cards/models/card_rarity.dart';
import 'package:mobile/features/cards/repositories/card_repository.dart';
import 'package:mobile/features/market/models/financial_history.dart';
import 'package:mobile/features/market/models/financial_quote.dart';
import 'package:mobile/features/market/repositories/market_repository.dart';

const _apple = AssetCardModel(
  id: 'card-1',
  collectionNumber: 1,
  rarity: CardRarity.legendary,
  rarityScore: 0.9,
  enabled: true,
  financialAssetId: 'asset-1',
  symbol: 'AAPL',
  name: 'Apple Inc.',
  assetType: 'STOCK',
);

class _FakeCardRepository implements CardRepository {
  List<AssetCardModel> cards;
  Object? error;

  _FakeCardRepository({this.cards = const [], this.error});

  @override
  Future<List<AssetCardModel>> getCards() async {
    final e = error;
    if (e != null) throw e;
    return cards;
  }
}

class _FakeMarketRepository implements MarketRepository {
  @override
  Future<FinancialQuote> getQuote(String id) async => FinancialQuote(
        financialAssetId: id,
        symbol: 'AAPL',
        name: 'Apple Inc.',
        assetType: 'STOCK',
        price: 123.45,
        currency: 'USD',
        changePercent: 1.2,
        change: 1.5,
      );

  @override
  Future<FinancialHistory> getHistory(String id) async =>
      FinancialHistory(financialAssetId: id, symbol: 'AAPL', points: const []);
}

Widget _app(CardRepository cards) => VestoryApp(
      dependencies: AppDependencies(
        cardRepository: cards,
        marketRepository: _FakeMarketRepository(),
      ),
    );

void main() {
  testWidgets('affiche les cartes renvoyées par le repository', (tester) async {
    await tester.pumpWidget(_app(_FakeCardRepository(cards: [_apple])));
    await tester.pumpAndSettle();

    expect(find.text('Apple Inc.'), findsOneWidget);
    expect(find.text('1/1'), findsOneWidget);
  });

  testWidgets('retourner la carte charge la cotation', (tester) async {
    await tester.pumpWidget(_app(_FakeCardRepository(cards: [_apple])));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Apple Inc.'));
    await tester.pumpAndSettle();

    expect(find.text('123.45 USD'), findsOneWidget);
  });

  testWidgets('affiche une erreur puis permet de réessayer', (tester) async {
    final repo = _FakeCardRepository(
      error: const ApiException('Unable to reach the server.'),
    );
    await tester.pumpWidget(_app(repo));
    await tester.pumpAndSettle();

    expect(find.textContaining('Unable to reach the server.'), findsOneWidget);

    repo
      ..error = null
      ..cards = [_apple];
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('Apple Inc.'), findsOneWidget);
  });

  testWidgets('liste vide', (tester) async {
    await tester.pumpWidget(_app(_FakeCardRepository()));
    await tester.pumpAndSettle();

    expect(find.text('No cards available.'), findsOneWidget);
  });
}
