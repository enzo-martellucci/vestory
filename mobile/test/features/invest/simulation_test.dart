import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/invest/data/models/price_point.dart';
import 'package:mobile/features/invest/domain/simulation.dart';

List<PricePoint> monthlyPrices(List<double> prices) => [
  for (final (index, price) in prices.indexed) PricePoint(date: DateTime.utc(2020, 1 + index), price: price),
];

void main() {
  test('a one-off investment follows the price', () {
    final result = simulate(prices: monthlyPrices([100, 120, 150, 200]), amount: 1000);

    expect(result.invested, 1000);
    expect(result.finalValue, closeTo(2000, 1e-9));
    expect(result.gain, closeTo(1000, 1e-9));
    expect(result.gainPercent, closeTo(1, 1e-9));
    expect(result.points.map((point) => point.value), [1000, 1200, 1500, closeTo(2000, 1e-9)]);
  });

  test('monthly contributions buy shares at each month price', () {
    final result = simulate(prices: monthlyPrices([100, 50, 100]), amount: 100, monthlyContribution: 100);

    expect(result.invested, 300);
    expect(result.finalValue, closeTo(400, 1e-9));
    expect(result.points.map((point) => point.invested), [100, 200, 300]);
  });

  test('the worst drop is measured from the previous peak', () {
    final result = simulate(prices: monthlyPrices([100, 150, 90, 120, 60, 200]), amount: 100);

    expect(result.maxDrawdown, closeTo(-0.6, 1e-9));
    expect(result.maxDrawdownDate, DateTime.utc(2020, 5));
  });

  test('no drop means a drawdown of zero', () {
    final result = simulate(prices: monthlyPrices([100, 110, 120]), amount: 100);

    expect(result.maxDrawdown, 0);
    expect(result.maxDrawdownDate, isNull);
  });

  test('the savings account grows by its yearly rate', () {
    final prices = monthlyPrices(List.generate(13, (index) => 100.0));
    final result = simulate(prices: prices, amount: 1000, savingsRate: 0.03);

    expect(result.savingsValue, closeTo(1030, 1e-6));
  });

  test('the annualized return is the yearly growth of the price', () {
    final prices = [
      PricePoint(date: DateTime.utc(2020), price: 100),
      PricePoint(date: DateTime.utc(2022), price: 121),
    ];
    final result = simulate(prices: prices, amount: 1000);

    expect(result.annualizedReturn, closeTo(0.10, 1e-3));
  });

  test('prices are sorted by date before simulating', () {
    final prices = monthlyPrices([100, 200]).reversed.toList();
    final result = simulate(prices: prices, amount: 100);

    expect(result.finalValue, closeTo(200, 1e-9));
  });

  test('a simulation needs at least two prices', () {
    expect(() => simulate(prices: monthlyPrices([100]), amount: 100), throwsArgumentError);
  });
}
