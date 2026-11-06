import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/core/time/year_month.dart';
import 'package:mobile/features/game/data/game_repository.dart';
import 'package:mobile/features/game/domain/game_rules.dart';
import 'package:mobile/features/game/domain/portfolio.dart';
import 'package:mobile/features/game/domain/trading.dart';
import 'package:mobile/features/market/domain/price_history.dart';
import 'package:mobile/features/packs/data/pack_repository.dart';
import 'package:mobile/features/packs/domain/pack_drawer.dart';
import 'package:mobile/features/packs/domain/pack_opening.dart';
import 'package:mobile/features/packs/domain/pack_type.dart';
import 'package:mobile/features/player/data/player_repository.dart';
import 'package:mobile/features/player/domain/player_rules.dart';

import 'fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase database;
  final now = DateTime(2026, 11, 3, 10);

  setUp(() => database = AppDatabase(NativeDatabase.memory()));
  tearDown(() => database.close());

  test('a new player gets the catalog and the starting gems', () async {
    await PlayerRepository(database).create(' enzo ');

    final player = await database.select(database.playerTable).getSingle();
    expect(player.username, 'enzo');
    expect(player.gems, startingGems);
    expect(await database.select(database.assetTable).get(), hasLength(200));
  });

  test('buying a pack pays for it, opens it and rewards duplicates', () async {
    await PlayerRepository(database).create('enzo');
    final packs = PackRepository(database, PackDrawer(FixedRandom(doubles: [0.0])));

    final first = await packs.buyAndOpen(PackType.standard, now);
    final second = await packs.buyAndOpen(PackType.standard, now);

    expect(first.isNew, isTrue);
    expect(second.isNew, isFalse);
    expect(second.gemsEarned, first.asset.rarity.duplicateGems);
    expect(second.asset.quantity, 2);
    expect(
      (await database.select(database.playerTable).getSingle()).gems,
      startingGems - 2 * PackType.standard.price + second.gemsEarned,
    );
  });

  test('a pack that is too expensive changes nothing', () async {
    await PlayerRepository(database).create('enzo');
    final packs = PackRepository(database, PackDrawer());

    await expectLater(packs.buyAndOpen(PackType.elite, now), throwsA(isA<PackException>()));

    final owned = await (database.select(database.assetTable)..where((asset) => asset.quantity.isBiggerThanValue(0))).get();
    expect(owned, isEmpty);
    expect((await database.select(database.playerTable).getSingle()).gems, startingGems);
  });

  test('the daily pack is free and opens once a day', () async {
    await PlayerRepository(database).create('enzo');
    final packs = PackRepository(database, PackDrawer(FixedRandom(doubles: [0.0])));

    await packs.openDailyPack(now);
    await expectLater(packs.openDailyPack(now), throwsA(isA<PackException>()));
    final second = await packs.openDailyPack(now.add(const Duration(days: 1)));

    expect(second.asset.quantity, 2);
    expect((await database.select(database.playerTable).getSingle()).gems, startingGems + second.gemsEarned);
  });

  test('a game buys and sells collection assets with its cash', () async {
    await PlayerRepository(database).create('enzo');
    final packs = PackRepository(database, PackDrawer(FixedRandom(doubles: [0.0])));
    final opening = await packs.buyAndOpen(PackType.standard, now);
    final games = GameRepository(database, FixedRandom(integer: 0));

    await games.start(now);
    await expectLater(games.start(now), throwsA(isA<TradeException>()));
    final game = (await games.watchCurrent().first)!;
    expect(game.startMonth, historyStartMonth);

    final notOwned = await (database.select(database.assetTable)..where((asset) => asset.quantity.equals(0))).get();
    await expectLater(
      games.buy(gameId: game.id, asset: notOwned.first, amount: 100, price: 10, now: now),
      throwsA(isA<TradeException>()),
    );

    await games.buy(gameId: game.id, asset: opening.asset, amount: 400, price: 20, now: now);
    await games.sell(gameId: game.id, assetId: opening.asset.id, quantity: 5, price: 30, now: now);
    await expectLater(
      games.sell(gameId: game.id, assetId: opening.asset.id, quantity: 16, price: 30, now: now),
      throwsA(isA<TradeException>()),
    );
    await expectLater(
      games.buy(gameId: game.id, asset: opening.asset, amount: 751, price: 20, now: now),
      throwsA(isA<TradeException>()),
    );

    final trades = await games.watchTrades(game.id).first;
    expect(cashAt(trades, game.startMonth), 750);
    expect(trades.map((trade) => trade.month), everyElement(const YearMonth(2005, 1)));
    expect(positionsAt(trades)[opening.asset.id]!.quantity, 15);

    await games.end(gameId: game.id, finalValue: 1200, endedAt: now);
    expect(await games.watchCurrent().first, isNull);
    expect((await games.watchFinished().first).single.performance, closeTo(0.2, 1e-9));
  });

  test('reset wipes the progress but keeps the catalog', () async {
    await PlayerRepository(database).create('enzo');
    await PackRepository(database, PackDrawer()).buyAndOpen(PackType.standard, now);

    await PlayerRepository(database).reset();

    expect(await database.select(database.playerTable).get(), isEmpty);
    final owned = await (database.select(database.assetTable)..where((asset) => asset.quantity.isBiggerThanValue(0))).get();
    expect(owned, isEmpty);
    expect(await database.select(database.assetTable).get(), hasLength(200));
  });
}
