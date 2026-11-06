import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/features/packs/domain/pack_type.dart';
import 'package:mobile/features/packs/presentation/opening/opening_pack.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  Future<void> pumpPack(WidgetTester tester, VoidCallback onHoldComplete) => tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: OpeningPack(
          type: PackType.standard,
          rarity: null,
          phase: OpeningPhase.ready,
          onHoldComplete: onHoldComplete,
          onBurstComplete: () {},
        ),
      ),
    ),
  );

  testWidgets('holding the pack long enough opens it', (tester) async {
    var opened = false;
    await pumpPack(tester, () => opened = true);

    final gesture = await tester.startGesture(tester.getCenter(find.byType(OpeningPack)));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 600));
    expect(opened, isFalse);

    await tester.pump(const Duration(milliseconds: 600));
    expect(opened, isTrue);
    await gesture.up();
  });

  testWidgets('releasing too early rewinds the hold', (tester) async {
    var opened = false;
    await pumpPack(tester, () => opened = true);

    final gesture = await tester.startGesture(tester.getCenter(find.byType(OpeningPack)));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 400));
    await gesture.up();
    await tester.pump(const Duration(milliseconds: 2000));

    expect(opened, isFalse);
  });
}
