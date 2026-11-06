import 'dart:math';

import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/core/time/year_month.dart';
import 'package:mobile/features/assets/domain/asset_type.dart';
import 'package:mobile/features/assets/domain/rarity.dart';
import 'package:mobile/features/game/domain/trade_type.dart';

class FixedRandom implements Random {
  final List<double> doubles;
  final int integer;
  var _index = 0;

  FixedRandom({this.doubles = const [0], this.integer = 0});

  @override
  double nextDouble() => doubles[_index++ % doubles.length];

  @override
  int nextInt(int max) => integer.clamp(0, max - 1);

  @override
  bool nextBool() => false;
}

Asset asset(int id, {Rarity rarity = Rarity.common, int quantity = 0}) => Asset(
  id: id,
  symbol: 'A$id',
  name: 'Asset $id',
  type: AssetType.stock,
  rarity: rarity,
  quantity: quantity,
);

Game game({YearMonth startMonth = const YearMonth(2010, 1), required DateTime startedAt, DateTime? endedAt}) =>
    Game(id: 1, startMonth: startMonth, startedAt: startedAt, endedAt: endedAt);

Trade trade(int id, TradeType type, {int assetId = 1, required double quantity, required double price, required YearMonth month}) =>
    Trade(id: id, gameId: 1, assetId: assetId, type: type, quantity: quantity, price: price, month: month);
