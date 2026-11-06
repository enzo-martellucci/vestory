import 'package:mobile/core/time/year_month.dart';

const historyStartMonth = YearMonth(2005, 1);

class PricePoint {
  final YearMonth month;
  final double price;

  const PricePoint(this.month, this.price);
}

class PriceHistory {
  final List<PricePoint> points;

  PriceHistory(Map<YearMonth, double> closes)
    : points = [for (final entry in closes.entries) PricePoint(entry.key, entry.value)]
        ..sort((a, b) => a.month.compareTo(b.month));

  YearMonth? get firstMonth => points.isEmpty ? null : points.first.month;

  double? priceAt(YearMonth month) {
    double? price;
    for (final point in points) {
      if (point.month.isAfter(month))
        break;
      price = point.price;
    }
    return price;
  }
}
