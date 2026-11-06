import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/time/year_month.dart';
import 'package:mobile/features/market/domain/price_history.dart';

void main() {
  final history = PriceHistory({
    const YearMonth(2010, 3): 12,
    const YearMonth(2010, 1): 10,
    const YearMonth(2010, 4): 13,
  });

  test('sorts the points and exposes the first month', () {
    expect(history.firstMonth, const YearMonth(2010, 1));
    expect([for (final point in history.points) point.price], [10, 12, 13]);
  });

  test('has no price before the asset was listed', () {
    expect(history.priceAt(const YearMonth(2009, 12)), isNull);
  });

  test('uses the last known price when a month is missing', () {
    expect(history.priceAt(const YearMonth(2010, 2)), 10);
    expect(history.priceAt(const YearMonth(2010, 3)), 12);
  });
}
