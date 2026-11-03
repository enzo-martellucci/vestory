import 'dart:math' as math;

import 'package:mobile/features/invest/data/models/price_point.dart';

class SimulationPoint {
  final DateTime date;
  final double invested;
  final double value;
  final double savingsValue;

  const SimulationPoint({required this.date, required this.invested, required this.value, required this.savingsValue});
}

class SimulationResult {
  final List<SimulationPoint> points;
  final double annualizedReturn;
  final double maxDrawdown;
  final DateTime? maxDrawdownDate;

  const SimulationResult({
    required this.points,
    required this.annualizedReturn,
    required this.maxDrawdown,
    required this.maxDrawdownDate,
  });

  double get invested => points.last.invested;

  double get finalValue => points.last.value;

  double get gain => finalValue - invested;

  double get gainPercent => invested == 0 ? 0 : gain / invested;

  double get savingsValue => points.last.savingsValue;
}

SimulationResult simulate({
  required List<PricePoint> prices,
  required double amount,
  double monthlyContribution = 0,
  double savingsRate = 0.03,
}) {
  if (prices.length < 2)
    throw ArgumentError('At least two prices are needed to run a simulation');
  if (amount <= 0 && monthlyContribution <= 0)
    throw ArgumentError('Something has to be invested');

  final sorted = [...prices]..sort((a, b) => a.date.compareTo(b.date));
  final monthlySavingsGrowth = math.pow(1 + savingsRate, 1 / 12).toDouble();

  var shares = amount / sorted.first.price;
  var invested = amount;
  var savings = amount;
  var peak = sorted.first.price;
  var maxDrawdown = 0.0;
  DateTime? maxDrawdownDate;

  final points = <SimulationPoint>[
    SimulationPoint(date: sorted.first.date, invested: invested, value: amount, savingsValue: savings),
  ];

  for (final point in sorted.skip(1)) {
    savings *= monthlySavingsGrowth;
    if (monthlyContribution > 0) {
      shares += monthlyContribution / point.price;
      invested += monthlyContribution;
      savings += monthlyContribution;
    }

    peak = math.max(peak, point.price);
    final drawdown = point.price / peak - 1;
    if (drawdown < maxDrawdown) {
      maxDrawdown = drawdown;
      maxDrawdownDate = point.date;
    }

    points.add(SimulationPoint(date: point.date, invested: invested, value: shares * point.price, savingsValue: savings));
  }

  final years = sorted.last.date.difference(sorted.first.date).inDays / 365.25;
  final priceRatio = sorted.last.price / sorted.first.price;

  return SimulationResult(
    points: points,
    annualizedReturn: years <= 0 ? 0 : math.pow(priceRatio, 1 / years) - 1,
    maxDrawdown: maxDrawdown,
    maxDrawdownDate: maxDrawdownDate,
  );
}
