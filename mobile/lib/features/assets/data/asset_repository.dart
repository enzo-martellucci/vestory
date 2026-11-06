import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/database/app_database.dart';

final assetRepositoryProvider = Provider<AssetRepository>((ref) => AssetRepository(ref.watch(appDatabaseProvider)));

class AssetRepository {
  final AppDatabase database;

  AssetRepository(this.database);

  Stream<List<Asset>> watchAll() =>
      (database.select(database.assetTable)..orderBy([(asset) => OrderingTerm.asc(asset.id)])).watch();

  Future<Asset> findById(int id) =>
      (database.select(database.assetTable)..where((asset) => asset.id.equals(id))).getSingle();
}
