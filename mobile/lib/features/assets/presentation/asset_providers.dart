import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/features/assets/data/asset_repository.dart';

final assetsProvider = StreamProvider<List<Asset>>((ref) => ref.watch(assetRepositoryProvider).watchAll());

final ownedAssetsProvider = Provider<AsyncValue<List<Asset>>>(
  (ref) => ref.watch(assetsProvider).whenData((assets) => [for (final asset in assets) if (asset.quantity > 0) asset]),
);

final recentAssetsProvider = Provider<AsyncValue<List<Asset>>>(
  (ref) => ref.watch(ownedAssetsProvider).whenData(
    (assets) => ([...assets]..sort((a, b) => b.lastObtainedAt!.compareTo(a.lastObtainedAt!))).take(8).toList(),
  ),
);
