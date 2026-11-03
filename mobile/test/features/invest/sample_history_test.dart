import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/invest/data/invest_repository.dart';
import 'package:mobile/features/invest/data/sample_history.dart';

void main() {
  final now = DateTime.utc(2026, 10, 15);

  test('one price per month over the requested years', () {
    final history = sampleMonthlyHistory(seed: 'asset', years: 5, now: now);

    expect(history, hasLength(5 * 12 + 1));
    expect(history.first.date, DateTime.utc(2021, 10));
    expect(history.last.date, DateTime.utc(2026, 10));
    for (var index = 1; index < history.length; index++)
      expect(history[index].date.isAfter(history[index - 1].date), isTrue);
  });

  test('prices stay positive', () {
    final history = sampleMonthlyHistory(seed: 'asset', years: 10, now: now);

    expect(history.every((point) => point.price > 0), isTrue);
  });

  test('the same asset always gets the same history', () {
    final first = sampleMonthlyHistory(seed: 'asset', years: 3, now: now);
    final second = sampleMonthlyHistory(seed: 'asset', years: 3, now: now);

    expect(first.map((point) => point.price), second.map((point) => point.price));
  });

  test('different assets get different histories', () {
    final first = sampleMonthlyHistory(seed: 'apple', years: 3, now: now);
    final second = sampleMonthlyHistory(seed: 'tesla', years: 3, now: now);

    expect(first.map((point) => point.price), isNot(second.map((point) => point.price)));
  });

  test('the repository returns the sample history', () async {
    final repository = InvestRepository(now: () => now);
    final history = await repository.getMonthlyHistory(1, 1);

    expect(history, hasLength(13));
  });
}
