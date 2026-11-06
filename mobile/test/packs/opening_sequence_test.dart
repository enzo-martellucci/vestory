import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/features/assets/domain/rarity.dart';
import 'package:mobile/features/assets/presentation/asset_card.dart';
import 'package:mobile/features/packs/presentation/opening/card_reveal.dart';
import 'package:mobile/features/packs/presentation/opening/rarity_effects.dart';
import 'package:mobile/features/packs/presentation/opening/walkout_sequence.dart';

import '../fixtures.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: Center(child: child)));

  group('WalkoutSequence', () {
    testWidgets('goes through the clues then completes', (tester) async {
      var completed = false;
      final walkout = asset(1, rarity: Rarity.epic);
      await tester.pumpWidget(wrap(WalkoutSequence(asset: walkout, onComplete: () => completed = true)));
      expect(find.text('EPIC'), findsOneWidget);

      await tester.pump(Rarity.epic.walkoutStepDuration);
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Stock'), findsOneWidget);
      expect(completed, isFalse);

      await tester.pump(Rarity.epic.walkoutStepDuration);
      expect(completed, isTrue);
    });

    testWidgets('can be skipped with a tap', (tester) async {
      var completed = false;
      await tester.pumpWidget(wrap(WalkoutSequence(asset: asset(1), onComplete: () => completed = true)));

      await tester.tap(find.byType(WalkoutSequence));
      expect(completed, isTrue);
    });
  });

  testWidgets('CardReveal flips the card by itself, then lets the player flip it', (tester) async {
    var revealed = false;
    await tester.pumpWidget(
      wrap(CardReveal(asset: asset(1, quantity: 1), total: 200, onRevealed: () => revealed = true, onDetails: () {})),
    );
    expect(find.byType(FlippableAssetCard), findsNothing);
    expect(find.text('V'), findsOneWidget);

    await tester.pump();
    await tester.pump(Rarity.common.revealDuration + const Duration(milliseconds: 100));
    await tester.pump();
    expect(revealed, isTrue);
    expect(find.byType(FlippableAssetCard), findsOneWidget);
    expect(find.text('V'), findsNothing);
  });
}
