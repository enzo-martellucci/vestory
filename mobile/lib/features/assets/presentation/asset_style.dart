import 'package:material_ui/material_ui.dart';
import 'package:mobile/features/assets/domain/asset_type.dart';
import 'package:mobile/features/assets/domain/rarity.dart';

extension RarityStyle on Rarity {
  Color get color => switch (this) {
    Rarity.common => const Color(0xFF8B93A7),
    Rarity.rare => const Color(0xFF2F80ED),
    Rarity.epic => const Color(0xFF9B51E0),
    Rarity.legendary => const Color(0xFFF2994A),
  };

  List<Color> get gradient => switch (this) {
    Rarity.common => const [Color(0xFFC5CAD6), Color(0xFF8B93A7)],
    Rarity.rare => const [Color(0xFF6FB1FF), Color(0xFF2F6BED)],
    Rarity.epic => const [Color(0xFFD08BFF), Color(0xFF7B3FE4)],
    Rarity.legendary => const [Color(0xFFFFD66B), Color(0xFFF2784A)],
  };
}

extension AssetTypeStyle on AssetType {
  IconData get icon => switch (this) {
    AssetType.stock => Icons.business_rounded,
    AssetType.etf => Icons.pie_chart_rounded,
    AssetType.crypto => Icons.currency_bitcoin_rounded,
    AssetType.forex => Icons.currency_exchange_rounded,
    AssetType.commodity => Icons.diamond_rounded,
  };
}
