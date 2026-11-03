import 'dart:math' as math;

import 'package:mobile/features/invest/data/models/price_point.dart';

const _yearlyDrift = 0.08;
const _yearlyVolatility = 0.2;
const _crashProbability = 0.02;

List<PricePoint> sampleMonthlyHistory({required String seed, required int years, required DateTime now}) {
  final random = math.Random(seed.codeUnits.fold<int>(17, (hash, unit) => (hash * 31 + unit) & 0x7fffffff));
  final months = years * 12;
  final start = DateTime.utc(now.year, now.month - months);
  const monthlyDrift = _yearlyDrift / 12;
  final monthlyVolatility = _yearlyVolatility / math.sqrt(12);

  var price = 50 + random.nextDouble() * 150;
  final points = <PricePoint>[];

  for (var month = 0; month <= months; month++) {
    points.add(PricePoint(date: DateTime.utc(start.year, start.month + month), price: double.parse(price.toStringAsFixed(2))));

    final shock = _normal(random) * monthlyVolatility;
    final crash = random.nextDouble() < _crashProbability ? -(0.1 + random.nextDouble() * 0.2) : 0.0;
    price = math.max(1, price * math.exp(monthlyDrift + shock + crash));
  }

  return points;
}

double _normal(math.Random random) {
  final u1 = 1 - random.nextDouble();
  final u2 = random.nextDouble();
  return math.sqrt(-2 * math.log(u1)) * math.cos(2 * math.pi * u2);
}
