import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/database/app_database.dart';

final jsonCacheProvider = Provider<JsonCache>((ref) => JsonCache(ref.watch(appDatabaseProvider)));

class CachedJson {
  final Map<String, dynamic> json;
  final DateTime fetchedAt;

  const CachedJson(this.json, this.fetchedAt);
}

class JsonCache {
  final AppDatabase database;

  JsonCache(this.database);

  Future<CachedJson?> read(String key) async {
    final query = database.select(database.cacheEntries)..where((entry) => entry.cacheKey.equals(key));
    final row = await query.getSingleOrNull();
    if (row == null)
      return null;
    return CachedJson(jsonDecode(row.payload) as Map<String, dynamic>, row.fetchedAt);
  }

  Future<void> write(String key, Map<String, dynamic> json, DateTime fetchedAt) {
    return database
        .into(database.cacheEntries)
        .insertOnConflictUpdate(CacheEntriesCompanion.insert(cacheKey: key, payload: jsonEncode(json), fetchedAt: fetchedAt));
  }
}
