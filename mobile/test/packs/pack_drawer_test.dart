import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/assets/domain/rarity.dart';
import 'package:mobile/features/packs/domain/pack_drawer.dart';
import 'package:mobile/features/packs/domain/pack_type.dart';

import '../fixtures.dart';

void main() {
  group('rollRarity', () {
    test('maps the roll onto the cumulative odds of the pack', () {
      expect(PackDrawer(FixedRandom(doubles: [0.0])).rollRarity(PackType.standard), Rarity.common);
      expect(PackDrawer(FixedRandom(doubles: [0.69])).rollRarity(PackType.standard), Rarity.common);
      expect(PackDrawer(FixedRandom(doubles: [0.70])).rollRarity(PackType.standard), Rarity.rare);
      expect(PackDrawer(FixedRandom(doubles: [0.95])).rollRarity(PackType.standard), Rarity.epic);
      expect(PackDrawer(FixedRandom(doubles: [0.995])).rollRarity(PackType.standard), Rarity.legendary);
    });

    test('never rolls a rarity the pack does not contain', () {
      expect(PackDrawer(FixedRandom(doubles: [0.0])).rollRarity(PackType.elite), Rarity.rare);
    });
  });

  group('closestAvailableRarity', () {
    test('keeps the wanted rarity when it is available', () {
      expect(closestAvailableRarity(Rarity.epic, Rarity.values.toSet()), Rarity.epic);
    });

    test('falls back to the lower rarity first', () {
      expect(closestAvailableRarity(Rarity.epic, {Rarity.rare, Rarity.legendary}), Rarity.rare);
    });

    test('falls back to a higher rarity when nothing lower exists', () {
      expect(closestAvailableRarity(Rarity.common, {Rarity.legendary}), Rarity.legendary);
    });

    test('fails when the catalog is empty', () {
      expect(() => closestAvailableRarity(Rarity.common, {}), throwsStateError);
    });
  });

  test('draw picks an asset of the rolled rarity', () {
    final catalog = [asset(1), asset(2, rarity: Rarity.rare), asset(3, rarity: Rarity.rare)];
    final drawer = PackDrawer(FixedRandom(doubles: [0.8], integer: 1));

    expect(drawer.draw(PackType.standard, catalog).id, 3);
  });

  test('duplicates give more gems for rarer cards', () {
    expect(Rarity.values.map((rarity) => rarity.duplicateGems), [2, 10, 50, 100]);
  });
}
