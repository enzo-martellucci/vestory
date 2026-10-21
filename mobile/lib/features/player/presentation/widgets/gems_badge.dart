import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/theme/app_colors.dart';

class GemsBadge extends StatelessWidget {
  final int gems;

  const GemsBadge({super.key, required this.gems});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: .min,
        spacing: 6,
        children: [
          const Icon(Icons.diamond, color: AppColors.rare, size: 18),
          Text('$gems', style: const TextStyle(fontWeight: .w800, color: AppColors.ink)),
        ],
      ),
    );
  }
}
