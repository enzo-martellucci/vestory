import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/format/formatters.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/animated_number.dart';

class GemBadge extends StatelessWidget {
  final int gems;

  const GemBadge({super.key, required this.gems});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: AppColors.gem.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.diamond_rounded, color: AppColors.gem, size: 18),
          const SizedBox(width: 6),
          AnimatedNumber(
            value: gems.toDouble(),
            format: (value) => formatGems(value.round()),
            style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink),
          ),
        ],
      ),
    );
  }
}
