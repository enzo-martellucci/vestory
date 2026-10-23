import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/player/data/models/pack_type.dart';

class PackVisual extends StatelessWidget {
  static const aspectRatio = 0.7;

  final PackType type;
  final double width;

  const PackVisual({super.key, required this.type, this.width = 96});

  static Color colorOf(PackType type) => switch (type) {
    PackType.standard => AppColors.rare,
    PackType.premium => AppColors.epic,
    PackType.elite => AppColors.legendary,
  };

  @override
  Widget build(BuildContext context) {
    final color = colorOf(type);

    return SizedBox(
      width: width,
      height: width / aspectRatio,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(width * 0.12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color.lerp(color, Colors.white, 0.25)!, color, Color.lerp(color, Colors.black, 0.35)!],
          ),
          border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: width * 0.02),
          boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 4))],
        ),
        child: Column(
          mainAxisAlignment: .center,
          spacing: width * 0.06,
          children: [
            Icon(Icons.auto_awesome, color: Colors.white, size: width * 0.32),
            Text(
              type.name.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: width * 0.12,
                fontWeight: .w900,
                letterSpacing: width * 0.01,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
