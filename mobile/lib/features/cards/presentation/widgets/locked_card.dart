import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/theme/app_colors.dart';

class LockedCard extends StatelessWidget {
  static const _greyscale = ColorFilter.matrix([
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0, 0, 0, 1, 0,
  ]);

  final Widget child;

  const LockedCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        alignment: .center,
        children: [
          ColorFiltered(colorFilter: _greyscale, child: Opacity(opacity: 0.55, child: child)),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.ink.withValues(alpha: 0.7), shape: BoxShape.circle),
            child: const Icon(Icons.lock, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }
}
