import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/theme/app_colors.dart';

class MainShell extends StatelessWidget {
  static const _tabs = [
    (icon: Icons.home_outlined, label: 'Home'),
    (icon: Icons.style_outlined, label: 'Collection'),
    (icon: Icons.shopping_bag_outlined, label: 'Shop'),
    (icon: Icons.trending_up, label: 'Invest'),
    (icon: Icons.person_outline, label: 'Profile'),
  ];

  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: [BoxShadow(color: AppColors.ink.withValues(alpha: 0.14), blurRadius: 32, offset: const Offset(0, 12))],
          ),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              for (final (index, tab) in _tabs.indexed)
                IconButton(
                  onPressed: () => navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex),
                  tooltip: tab.label,
                  icon: Icon(tab.icon),
                  style: IconButton.styleFrom(
                    fixedSize: const Size.square(52),
                    backgroundColor: index == navigationShell.currentIndex ? AppColors.indigo : Colors.transparent,
                    foregroundColor: index == navigationShell.currentIndex ? Colors.white : AppColors.muted,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
