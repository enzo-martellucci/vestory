import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/theme/app_colors.dart';

class MainShell extends StatelessWidget {
  static const _icons = [
    Icons.home_rounded,
    Icons.style_rounded,
    Icons.storefront_rounded,
    Icons.show_chart_rounded,
    Icons.person_rounded,
  ];

  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.ink,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [BoxShadow(color: AppColors.ink.withValues(alpha: 0.3), blurRadius: 24, offset: const Offset(0, 10))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (final (index, icon) in _icons.indexed)
                _NavItem(
                  icon: icon,
                  selected: navigationShell.currentIndex == index,
                  onTap: () => navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        width: 48,
        height: 48,
        decoration: BoxDecoration(color: selected ? AppColors.primary : Colors.transparent, shape: BoxShape.circle),
        child: AnimatedScale(
          scale: selected ? 1.1 : 1,
          duration: const Duration(milliseconds: 250),
          child: Icon(icon, color: selected ? Colors.white : Colors.white54),
        ),
      ),
    );
  }
}
