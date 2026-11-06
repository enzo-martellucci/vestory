import 'dart:math';

import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/core/time/clock.dart';
import 'package:mobile/core/time/year_month.dart';
import 'package:mobile/features/market/domain/price_history.dart';

const initialCash = 1000.0;
const gameDurationMonths = 60;

YearMonth latestStartMonth(DateTime now) => YearMonth.of(now).plus(-gameDurationMonths - 1);

YearMonth pickStartMonth(Random random, DateTime now) {
  final span = historyStartMonth.monthsUntil(latestStartMonth(now));
  return historyStartMonth.plus(random.nextInt(span + 1));
}

double performanceOf(double value) => value / initialCash - 1;

double? bestPerformance(List<Game> games) =>
    games.isEmpty ? null : games.map((game) => game.performance ?? 0).reduce(max);

extension GameRules on Game {
  int elapsedMonths(DateTime now) => calendarDaysBetween(startedAt, endedAt ?? now).clamp(0, gameDurationMonths);

  YearMonth currentMonth(DateTime now) => startMonth.plus(elapsedMonths(now));

  bool get isFinished => endedAt != null;

  bool isOver(DateTime now) => !isFinished && elapsedMonths(now) >= gameDurationMonths;

  double? get performance => finalValue == null ? null : performanceOf(finalValue!);
}
