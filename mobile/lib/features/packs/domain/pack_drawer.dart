import 'dart:math';

import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/features/assets/domain/rarity.dart';
import 'package:mobile/features/packs/domain/pack_type.dart';

class PackDrawer {
  final Random random;

  PackDrawer([Random? random]) : random = random ?? Random();

  Asset draw(PackType type, List<Asset> catalog) {
    final assetsByRarity = <Rarity, List<Asset>>{};
    for (final asset in catalog)
      assetsByRarity.putIfAbsent(asset.rarity, () => []).add(asset);

    final rarity = closestAvailableRarity(rollRarity(type), assetsByRarity.keys.toSet());
    final pool = assetsByRarity[rarity]!;
    return pool[random.nextInt(pool.length)];
  }

  Rarity rollRarity(PackType type) {
    final roll = random.nextDouble();
    var cumulative = 0.0;
    Rarity? last;

    for (final rarity in Rarity.values) {
      final odds = type.oddsOf(rarity);
      if (odds <= 0)
        continue;
      cumulative += odds;
      last = rarity;
      if (roll < cumulative)
        return rarity;
    }

    return last!;
  }
}

Rarity closestAvailableRarity(Rarity wanted, Set<Rarity> available) {
  for (var distance = 0; distance < Rarity.values.length; distance++) {
    final lower = wanted.index - distance;
    if (lower >= 0 && available.contains(Rarity.values[lower]))
      return Rarity.values[lower];

    final higher = wanted.index + distance;
    if (higher < Rarity.values.length && available.contains(Rarity.values[higher]))
      return Rarity.values[higher];
  }

  throw StateError('No asset available to draw');
}
