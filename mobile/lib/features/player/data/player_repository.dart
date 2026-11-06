import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/features/player/domain/player_rules.dart';

final playerRepositoryProvider = Provider<PlayerRepository>((ref) => PlayerRepository(ref.watch(appDatabaseProvider)));

class PlayerRepository {
  final AppDatabase database;

  PlayerRepository(this.database);

  Stream<Player?> watch() => database.select(database.playerTable).watchSingleOrNull();

  Future<void> create(String username) => database.into(database.playerTable).insert(
    PlayerTableCompanion.insert(username: username.trim(), gems: startingGems),
  );

  Future<void> addGems(int amount) => database.transaction(() async {
    final player = await database.select(database.playerTable).getSingle();
    await database.update(database.playerTable).write(PlayerTableCompanion(gems: Value(player.gems + amount)));
  });

  Future<void> resetDailyPack() =>
      database.update(database.playerTable).write(const PlayerTableCompanion(lastDailyPackAt: Value(null)));

  Future<void> reset() => database.transaction(() async {
    await database.delete(database.tradeTable).go();
    await database.delete(database.gameTable).go();
    await database.delete(database.playerTable).go();
    await database.update(database.assetTable).write(
      const AssetTableCompanion(quantity: Value(0), lastObtainedAt: Value(null)),
    );
  });
}
