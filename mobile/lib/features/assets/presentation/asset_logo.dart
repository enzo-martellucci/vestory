import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/features/assets/presentation/asset_style.dart';

class AssetLogo extends StatelessWidget {
  final Asset asset;
  final double size;

  const AssetLogo({super.key, required this.asset, this.size = 44});

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: asset.rarity.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      alignment: Alignment.center,
      child: Icon(asset.type.icon, color: Colors.white, size: size * 0.5),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.3),
      child: SizedBox.square(
        dimension: size,
        child: asset.logoUrl == null
            ? fallback
            : ColoredBox(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(size * 0.12),
                  child: Image.network(asset.logoUrl!, fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) => fallback),
                ),
              ),
      ),
    );
  }
}
