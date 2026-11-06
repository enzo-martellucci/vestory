import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/packs/domain/daily_pack.dart';

void main() {
  group('isDailyPackAvailable', () {
    final now = DateTime(2026, 3, 10, 9, 30);

    test('is available when it was never claimed', () {
      expect(isDailyPackAvailable(null, now), isTrue);
    });

    test('is not available twice the same day', () {
      expect(isDailyPackAvailable(DateTime(2026, 3, 10, 0, 1), now), isFalse);
    });

    test('is available again after midnight', () {
      expect(isDailyPackAvailable(DateTime(2026, 3, 9, 23, 59), now), isTrue);
    });
  });

  test('nextDailyPackAt is the next midnight', () {
    expect(nextDailyPackAt(DateTime(2026, 12, 31, 18)), DateTime(2027, 1, 1));
  });
}
