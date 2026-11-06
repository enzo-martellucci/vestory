import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/features/game/domain/game_rules.dart';
import 'package:mobile/features/game/domain/portfolio.dart';
import 'package:mobile/features/game/domain/trade_type.dart';
import 'package:mobile/features/game/domain/trading.dart';

final gameRepositoryProvider = Provider<GameRepository>((ref) => GameRepository(ref.watch(appDatabaseProvider)));

class GameRepository {
  final AppDatabase database;
  final Random random;

  GameRepository(this.database, [Random? random]) : random = random ?? Random();

  Stream<Game?> watchCurrent() =>
      (database.select(database.gameTable)..where((game) => game.endedAt.isNull())).watchSingleOrNull();

  Stream<List<Game>> watchFinished() => (database.select(database.gameTable)
        ..where((game) => game.endedAt.isNotNull())
        ..orderBy([(game) => OrderingTerm.desc(game.id)]))
      .watch();

  Stream<List<Trade>> watchTrades(int gameId) => _tradesOf(gameId).watch();

  Future<void> start(DateTime now) => database.transaction(() async {
    final current = await (database.select(database.gameTable)..where((game) => game.endedAt.isNull())).getSingleOrNull();
    if (current != null)
      throw const TradeException('A game is already in progress.');

    await database.into(database.gameTable).insert(
      GameTableCompanion.insert(startMonth: pickStartMonth(random, now), startedAt: now),
    );
  });

  Future<void> buy({required int gameId, required Asset asset, required double amount, required double price, required DateTime now}) =>
      database.transaction(() async {
        final game = await _findGame(gameId, now);
        if (asset.quantity == 0)
          throw const TradeException('You can only invest in assets from your collection.');

        final month = game.currentMonth(now);
        final trades = await _tradesOf(gameId).get();
        final quantity = buyQuantity(amount: amount, cash: cashAt(trades, month), price: price);
        await _insertTrade(game, asset.id, TradeType.buy, quantity, price, now);
      });

  Future<void> sell({required int gameId, required int assetId, required double quantity, required double price, required DateTime now}) =>
      database.transaction(() async {
        final game = await _findGame(gameId, now);
        final trades = await _tradesOf(gameId).get();
        sellProceeds(quantity: quantity, held: positionsAt(trades)[assetId]?.quantity ?? 0, price: price);
        await _insertTrade(game, assetId, TradeType.sell, quantity, price, now);
      });

  Future<void> end({required int gameId, required double finalValue, required DateTime endedAt}) =>
      (database.update(database.gameTable)..where((game) => game.id.equals(gameId))).write(
        GameTableCompanion(endedAt: Value(endedAt), finalValue: Value(finalValue)),
      );

  SimpleSelectStatement<$TradeTableTable, Trade> _tradesOf(int gameId) => database.select(database.tradeTable)
    ..where((trade) => trade.gameId.equals(gameId))
    ..orderBy([(trade) => OrderingTerm.asc(trade.id)]);

  Future<void> _insertTrade(Game game, int assetId, TradeType type, double quantity, double price, DateTime now) =>
      database.into(database.tradeTable).insert(TradeTableCompanion.insert(
        gameId: game.id,
        assetId: assetId,
        type: type,
        quantity: quantity,
        price: price,
        month: game.currentMonth(now),
      ));

  Future<Game> _findGame(int gameId, DateTime now) async {
    final game = await (database.select(database.gameTable)..where((row) => row.id.equals(gameId))).getSingle();
    if (game.isFinished || game.isOver(now))
      throw const TradeException('This game is over.');
    return game;
  }
}
