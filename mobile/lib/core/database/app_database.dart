import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/time/year_month.dart';
import 'package:mobile/features/assets/domain/asset_type.dart';
import 'package:mobile/features/assets/domain/rarity.dart';
import 'package:mobile/features/game/domain/trade_type.dart';

part 'app_database.g.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

class YearMonthConverter extends TypeConverter<YearMonth, int> {
  const YearMonthConverter();

  @override
  YearMonth fromSql(int fromDb) => YearMonth.fromIndex(fromDb);

  @override
  int toSql(YearMonth value) => value.index;
}

@DataClassName('Player')
class PlayerTable extends Table {
  @override
  String get tableName => 'player';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text()();
  IntColumn get gems => integer()();
  DateTimeColumn get lastDailyPackAt => dateTime().nullable()();
}

@DataClassName('Asset')
class AssetTable extends Table {
  @override
  String get tableName => 'asset';

  IntColumn get id => integer()();
  TextColumn get symbol => text()();
  TextColumn get name => text()();
  TextColumn get type => textEnum<AssetType>()();
  TextColumn get rarity => textEnum<Rarity>()();
  TextColumn get marketSymbol => text().nullable()();
  TextColumn get micCode => text().nullable()();
  TextColumn get exchange => text().nullable()();
  TextColumn get country => text().nullable()();
  TextColumn get currency => text().nullable()();
  TextColumn get sector => text().nullable()();
  TextColumn get industry => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get logoUrl => text().nullable()();
  IntColumn get quantity => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastObtainedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Game')
class GameTable extends Table {
  @override
  String get tableName => 'game';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get startMonth => integer().map(const YearMonthConverter())();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  RealColumn get finalValue => real().nullable()();
}

@DataClassName('Trade')
class TradeTable extends Table {
  @override
  String get tableName => 'trade';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get gameId => integer().references(GameTable, #id)();
  IntColumn get assetId => integer().references(AssetTable, #id)();
  TextColumn get type => textEnum<TradeType>()();
  RealColumn get quantity => real()();
  RealColumn get price => real()();
  IntColumn get month => integer().map(const YearMonthConverter())();
}

@DriftDatabase(tables: [PlayerTable, AssetTable, GameTable, TradeTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? driftDatabase(name: 'vestory_game'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
      await _seedAssets();
    },
    beforeOpen: (details) => customStatement('PRAGMA foreign_keys = ON'),
  );

  Future<void> _seedAssets() async {
    var id = 1;
    for (final type in AssetType.values) {
      final content = await rootBundle.loadString('assets/data/${type.name}.json');
      final entries = (jsonDecode(content) as List<dynamic>).cast<Map<String, dynamic>>();
      await batch((batch) {
        for (final entry in entries)
          batch.insert(
            assetTable,
            AssetTableCompanion.insert(
              id: Value(id++),
              symbol: entry['symbol'] as String,
              name: entry['name'] as String,
              type: type,
              rarity: Rarity.values.byName((entry['rarity'] as String).toLowerCase()),
              marketSymbol: Value(entry['marketSymbol'] as String?),
              micCode: Value(entry['micCode'] as String?),
              exchange: Value(entry['exchange'] as String?),
              country: Value(entry['country'] as String?),
              currency: Value(entry['currency'] as String?),
              sector: Value(entry['sector'] as String?),
              industry: Value(entry['industry'] as String?),
              description: Value(entry['description'] as String?),
              logoUrl: Value(entry['logoUrl'] as String?),
            ),
          );
      });
    }
  }
}
