import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/cards/models/asset_card_model.dart';
import 'package:mobile/features/cards/models/card_rarity.dart';
import 'package:mobile/features/cards/widgets/verso/financial_row.dart';
import 'package:mobile/features/market/models/financial_quote.dart';

void main() {
  group('CardRarity.fromApi', () {
    test('reconnaît les valeurs du backend', () {
      expect(CardRarity.fromApi('LEGENDARY'), CardRarity.legendary);
      expect(CardRarity.fromApi('EPIC'), CardRarity.epic);
      expect(CardRarity.fromApi('RARE'), CardRarity.rare);
    });

    test('valeur inconnue ou nulle → common', () {
      expect(CardRarity.fromApi('MYTHIC'), CardRarity.common);
      expect(CardRarity.fromApi(null), CardRarity.common);
    });
  });

  test('AssetCardModel.fromJson', () {
    final card = AssetCardModel.fromJson({
      'id': 'c1',
      'collectionNumber': 3,
      'rarity': 'EPIC',
      'rarityScore': 0.5,
      'enabled': true,
      'financialAssetId': 'a1',
      'symbol': 'MSFT',
      'name': 'Microsoft',
      'assetType': 'STOCK',
      'logoUrl': null,
      'description': null,
    });

    expect(card.rarity, CardRarity.epic);
    expect(card.collectionNumber, 3);
    expect(card.logoUrl, isNull);
  });

  group('FinancialQuote.fromJson', () {
    Map<String, dynamic> base() => {
          'financialAssetId': 'a1',
          'symbol': 'MSFT',
          'name': 'Microsoft',
          'assetType': 'STOCK',
        };

    test('accepte les nombres envoyés en chaîne', () {
      final q = FinancialQuote.fromJson({...base(), 'price': '412.5'});
      expect(q.price, 412.5);
    });

    test('refuse une cotation sans prix', () {
      expect(() => FinancialQuote.fromJson(base()), throwsFormatException);
    });
  });

  test('FinancialRow.formatValue', () {
    expect(FinancialRow.formatValue(null), '—');
    expect(FinancialRow.formatValue(12.345), '12.35');
    expect(FinancialRow.formatValue(2500, compact: true), '2.5 k');
    expect(FinancialRow.formatValue(3.2e9, compact: true), '3.2 Md');
  });
}
