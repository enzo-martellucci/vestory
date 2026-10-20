import 'dart:convert';

import '../database/app_database.dart';

class CachedJson {
  final Map<String, dynamic> json;
  final DateTime fetchedAt;

  const CachedJson(this.json, this.fetchedAt);
}

abstract interface class JsonCache {
  Future<CachedJson?> read(String key);

  Future<void> write(String key, Map<String, dynamic> json, DateTime fetchedAt);
}

class DriftJsonCache implements JsonCache {
  final AppDatabase _database;

  const DriftJsonCache(this._database);

  @override
  Future<CachedJson?> read(String key) async {
    final query = _database.select(_database.cacheEntries)
      ..where((entry) => entry.cacheKey.equals(key));
    final row = await query.getSingleOrNull();
    if (row == null) return null;
    return CachedJson(jsonDecode(row.payload) as Map<String, dynamic>, row.fetchedAt);
  }

  @override
  Future<void> write(String key, Map<String, dynamic> json, DateTime fetchedAt) {
    return _database.into(_database.cacheEntries).insertOnConflictUpdate(
      CacheEntriesCompanion.insert(
        cacheKey: key,
        payload: jsonEncode(json),
        fetchedAt: fetchedAt,
      ),
    );
  }
}