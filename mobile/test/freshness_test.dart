import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/formatting/freshness.dart';

void main() {
  final now = DateTime(2026, 10, 20, 15, 30);

  test('shows only the time when the data was fetched today', () {
    expect(freshnessLabel(DateTime(2026, 10, 20, 9, 5), now), 'Updated today at 09:05');
  });

  test('shows the date when the data was fetched on a previous day', () {
    expect(freshnessLabel(DateTime(2026, 10, 18, 17, 42), now), 'Updated on 18/10 at 17:42');
  });

  test('compares calendar days, not 24-hour periods', () {
    expect(isSameDay(DateTime(2026, 10, 20, 0, 0), DateTime(2026, 10, 20, 23, 59)), isTrue);
    expect(isSameDay(DateTime(2026, 10, 20, 23, 59), DateTime(2026, 10, 21, 0, 0)), isFalse);
  });
}