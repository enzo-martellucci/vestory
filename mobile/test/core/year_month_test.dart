import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/time/year_month.dart';

void main() {
  test('handles year boundaries', () {
    expect(const YearMonth(2010, 12).plus(1), const YearMonth(2011, 1));
    expect(const YearMonth(2011, 1).plus(-1), const YearMonth(2010, 12));
    expect(YearMonth.parse('2015-07-01'), const YearMonth(2015, 7));
    expect(const YearMonth(2010, 1).monthsUntil(const YearMonth(2015, 1)), 60);
  });
}
