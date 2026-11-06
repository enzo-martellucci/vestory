import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/core/time/year_month.dart';
import 'package:mobile/features/game/domain/game_rules.dart';
import 'package:mobile/features/market/domain/price_history.dart';

import '../fixtures.dart';

void main() {
  final startedAt = DateTime(2026, 1, 1, 22);

  group('game clock', () {
    test('one real day moves the market forward one month', () {
      final current = game(startedAt: startedAt);

      expect(current.currentMonth(DateTime(2026, 1, 1, 23)), const YearMonth(2010, 1));
      expect(current.currentMonth(DateTime(2026, 1, 2, 0, 1)), const YearMonth(2010, 2));
      expect(current.currentMonth(DateTime(2026, 2, 1)), const YearMonth(2012, 8));
    });

    test('stops at the end of the game', () {
      final current = game(startedAt: startedAt);
      final later = DateTime(2026, 6, 1);

      expect(current.elapsedMonths(later), gameDurationMonths);
      expect(current.currentMonth(later), const YearMonth(2015, 1));
      expect(current.isOver(later), isTrue);
    });

    test('freezes once the game has ended', () {
      final ended = game(startedAt: startedAt, endedAt: DateTime(2026, 1, 11));

      expect(ended.elapsedMonths(DateTime(2026, 5, 1)), 10);
      expect(ended.isOver(DateTime(2026, 5, 1)), isFalse);
    });
  });

  group('start month', () {
    final now = DateTime(2026, 11, 3);

    test('leaves room for a full game before today', () {
      expect(latestStartMonth(now), const YearMonth(2021, 10));
      expect(latestStartMonth(now).plus(gameDurationMonths).isBefore(YearMonth.of(now)), isTrue);
    });

    test('is picked between the earliest and the latest start month', () {
      expect(pickStartMonth(FixedRandom(integer: 0), now), historyStartMonth);
      expect(pickStartMonth(FixedRandom(integer: 1 << 30), now), latestStartMonth(now));
    });
  });

  test('performance compares the value with the initial cash', () {
    expect(performanceOf(1250), closeTo(0.25, 1e-9));
    expect(performanceOf(800), closeTo(-0.2, 1e-9));
  });

  test('bestPerformance keeps the best finished game', () {
    final finished = [
      Game(id: 1, startMonth: const YearMonth(2010, 1), startedAt: startedAt, finalValue: 800),
      Game(id: 2, startMonth: const YearMonth(2011, 1), startedAt: startedAt, finalValue: 1500),
    ];

    expect(bestPerformance([]), isNull);
    expect(bestPerformance(finished), closeTo(0.5, 1e-9));
  });
}
