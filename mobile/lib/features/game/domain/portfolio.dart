import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/core/time/year_month.dart';
import 'package:mobile/features/game/domain/game_rules.dart';
import 'package:mobile/features/game/domain/trade_type.dart';
import 'package:mobile/features/game/domain/trading.dart';

typedef PriceLookup = double? Function(int assetId, YearMonth month);

class Position {
  final int assetId;
  final double quantity;
  final double cost;

  const Position({required this.assetId, required this.quantity, required this.cost});

  double get averagePrice => cost / quantity;
}

class ValuePoint {
  final YearMonth month;
  final double value;

  const ValuePoint(this.month, this.value);
}

class Holding {
  final Asset asset;
  final Position position;
  final double price;

  const Holding({required this.asset, required this.position, required this.price});

  double get value => position.quantity * price;

  double get gain => value - position.cost;

  double get gainPercent => position.cost == 0 ? 0 : gain / position.cost;
}

class Portfolio {
  final Game game;
  final YearMonth month;
  final int elapsedMonths;
  final double cash;
  final List<Holding> holdings;
  final List<ValuePoint> curve;
  final List<Trade> trades;

  const Portfolio({
    required this.game,
    required this.month,
    required this.elapsedMonths,
    required this.cash,
    required this.holdings,
    required this.curve,
    required this.trades,
  });

  double get holdingsValue => holdings.fold(0, (total, holding) => total + holding.value);

  double get totalValue => cash + holdingsValue;

  double get performance => performanceOf(totalValue);

  int get remainingMonths => gameDurationMonths - elapsedMonths;
}

Map<int, Position> positionsAt(List<Trade> trades, {YearMonth? upTo}) {
  final quantities = <int, double>{};
  final costs = <int, double>{};

  for (final trade in trades) {
    if (upTo != null && trade.month.isAfter(upTo))
      continue;

    final held = quantities[trade.assetId] ?? 0;
    final cost = costs[trade.assetId] ?? 0;
    if (trade.type == TradeType.buy) {
      quantities[trade.assetId] = held + trade.quantity;
      costs[trade.assetId] = cost + trade.quantity * trade.price;
    } else {
      final remaining = held - trade.quantity;
      quantities[trade.assetId] = remaining;
      costs[trade.assetId] = held <= 0 ? 0 : cost * remaining / held;
    }
  }

  return {
    for (final entry in quantities.entries)
      if (entry.value > quantityTolerance)
        entry.key: Position(assetId: entry.key, quantity: entry.value, cost: costs[entry.key]!),
  };
}

double cashAt(List<Trade> trades, YearMonth month) {
  var cash = initialCash;
  for (final trade in trades) {
    if (trade.month.isAfter(month))
      continue;
    final amount = trade.quantity * trade.price;
    cash += trade.type == TradeType.sell ? amount : -amount;
  }
  return cash;
}

double holdingsValueAt(Map<int, Position> positions, YearMonth month, PriceLookup price) => positions.values.fold(
  0,
  (total, position) => total + position.quantity * (price(position.assetId, month) ?? position.averagePrice),
);

List<ValuePoint> valueCurve({
  required YearMonth start,
  required YearMonth current,
  required List<Trade> trades,
  required PriceLookup price,
}) => [
  for (var month = start; !month.isAfter(current); month = month.plus(1))
    ValuePoint(month, cashAt(trades, month) + holdingsValueAt(positionsAt(trades, upTo: month), month, price)),
];
