import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/player/data/models/pack.dart';
import 'package:mobile/features/player/presentation/widgets/pack_visual.dart';

class ShopShortcut extends StatelessWidget {
  const ShopShortcut({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => context.go('/shop'),
        child: Ink(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [AppColors.legendaryTint, Colors.white],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            spacing: 18,
            children: [
              Transform.rotate(angle: -0.12, child: const PackVisual(type: PackType.elite, width: 56)),
              const Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: 4,
                  children: [
                    Text('Get more packs', style: TextStyle(fontSize: 18, fontWeight: .w900)),
                    Text('Standard, Premium and Elite packs are waiting in the shop', style: TextStyle(color: AppColors.muted)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.indigo, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}
