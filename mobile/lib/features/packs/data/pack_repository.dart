import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/features/packs/domain/daily_pack.dart';
import 'package:mobile/features/packs/domain/pack_drawer.dart';
import 'package:mobile/features/packs/domain/pack_opening.dart';
import 'package:mobile/features/packs/domain/pack_type.dart';

final packDrawerProvider = Provider<PackDrawer>((ref) => PackDrawer());

final packRepositoryProvider = Provider<PackRepository>(
  (ref) => PackRepository(ref.watch(appDatabaseProvider), ref.watch(packDrawerProvider)),
);

class PackRepository {
  final AppDatabase database;
  final PackDrawer drawer;

  PackRepository(this.database, this.drawer);

  Future<PackOpening> openDailyPack(DateTime now) => database.transaction(() async {
    final player = await database.select(database.playerTable).getSingle();
    if (!isDailyPackAvailable(player.lastDailyPackAt, now))
      throw const PackException('Your daily pack has already been opened today.');

    await database.update(database.playerTable).write(PlayerTableCompanion(lastDailyPackAt: Value(now)));
    return _draw(dailyPackType, player.gems, now);
  });

  Future<PackOpening> buyAndOpen(PackType type, DateTime now) => database.transaction(() async {
    final player = await database.select(database.playerTable).getSingle();
    if (player.gems < type.price)
      throw const PackException('Not enough gems for this pack.');

    return _draw(type, player.gems - type.price, now);
  });

  Future<PackOpening> _draw(PackType type, int gems, DateTime now) async {
    final catalog = await database.select(database.assetTable).get();
    final drawn = drawer.draw(type, catalog);
    final isNew = drawn.quantity == 0;
    final gemsEarned = isNew ? 0 : drawn.rarity.duplicateGems;
    final asset = drawn.copyWith(quantity: drawn.quantity + 1, lastObtainedAt: Value(now));

    await database.update(database.assetTable).replace(asset);
    await database.update(database.playerTable).write(PlayerTableCompanion(gems: Value(gems + gemsEarned)));

    return PackOpening(asset: asset, isNew: isNew, gemsEarned: gemsEarned);
  }
}
