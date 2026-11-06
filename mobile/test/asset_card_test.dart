import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/features/assets/presentation/asset_card.dart';

import 'fixtures.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  Future<void> pumpCard(WidgetTester tester, double width) => tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: width,
            child: FlippableAssetCard(asset: asset(1, quantity: 1), total: 200, onDetails: () {}),
          ),
        ),
      ),
    ),
  );

  for (final width in [140.0, 180.0])
    testWidgets('flips to the back and back again at width $width', (tester) async {
      await pumpCard(tester, width);
      expect(find.byType(AssetCardFront), findsOneWidget);

      await tester.tap(find.byType(FlippableAssetCard));
      await tester.pump(const Duration(milliseconds: 200));
      final midFlip = tester.widget<Transform>(find.descendant(of: find.byType(FlippableAssetCard), matching: find.byType(Transform)).first);
      expect(midFlip.transform.isIdentity(), isFalse);

      await tester.pumpAndSettle();
      expect(find.byType(AssetCardBack), findsOneWidget);

      await tester.tap(find.byType(FlippableAssetCard));
      await tester.pumpAndSettle();
      expect(find.byType(AssetCardFront), findsOneWidget);
    });
}
