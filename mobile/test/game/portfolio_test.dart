import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/time/year_month.dart';
import 'package:mobile/features/game/domain/game_rules.dart';
import 'package:mobile/features/game/domain/portfolio.dart';
import 'package:mobile/features/game/domain/trade_type.dart';
import 'package:mobile/features/game/domain/trading.dart';

import '../fixtures.dart';

void main() {
  const january = YearMonth(2010, 1);
  const february = YearMonth(2010, 2);
  const march = YearMonth(2010, 3);

  group('buyQuantity', () {
    test('converts the amount into a fractional quantity', () {
      expect(buyQuantity(amount: 250, cash: 1000, price: 100), 2.5);
    });

    test('rejects invalid orders', () {
      expect(() => buyQuantity(amount: 0, cash: 1000, price: 100), throwsA(isA<TradeException>()));
      expect(() => buyQuantity(amount: 1001, cash: 1000, price: 100), throwsA(isA<TradeException>()));
      expect(() => buyQuantity(amount: 100, cash: 1000, price: null), throwsA(isA<TradeException>()));
    });
  });

  group('sellProceeds', () {
    test('multiplies the quantity by the price', () {
      expect(sellProceeds(quantity: 2, held: 3, price: 50), 100);
    });

    test('rejects selling more than held', () {
      expect(() => sellProceeds(quantity: 3.5, held: 3, price: 50), throwsA(isA<TradeException>()));
      expect(() => sellProceeds(quantity: 0, held: 3, price: 50), throwsA(isA<TradeException>()));
    });
  });

  group('positionsAt', () {
    final trades = [
      trade(1, TradeType.buy, quantity: 2, price: 100, month: january),
      trade(2, TradeType.buy, quantity: 2, price: 200, month: february),
      trade(3, TradeType.sell, quantity: 1, price: 300, month: march),
    ];

    test('uses the average cost and keeps it after a partial sale', () {
      final position = positionsAt(trades)[1]!;

      expect(position.quantity, 3);
      expect(position.averagePrice, 150);
      expect(position.cost, 450);
    });

    test('can be computed at a past month', () {
      expect(positionsAt(trades, upTo: january)[1]!.quantity, 2);
    });

    test('drops positions that were fully sold', () {
      final sold = [...trades, trade(4, TradeType.sell, quantity: 3, price: 300, month: march)];

      expect(positionsAt(sold), isEmpty);
    });
  });

  test('cashAt replays every trade up to the month', () {
    final trades = [
      trade(1, TradeType.buy, quantity: 2, price: 100, month: january),
      trade(2, TradeType.sell, quantity: 1, price: 150, month: march),
    ];

    expect(cashAt(trades, january), initialCash - 200);
    expect(cashAt(trades, february), initialCash - 200);
    expect(cashAt(trades, march), initialCash - 50);
  });

  test('valueCurve values cash and holdings every month', () {
    final prices = {january: 100.0, february: 120.0, march: 90.0};
    final curve = valueCurve(
      start: january,
      current: march,
      trades: [trade(1, TradeType.buy, quantity: 5, price: 100, month: january)],
      price: (assetId, month) => prices[month],
    );

    expect([for (final point in curve) point.value], [1000, 1100, 950]);
  });
}
