import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  final String username;
  final int gems;
  final int ownedCards;
  final int totalCards;
  final int unopenedPacks;

  const HomeHeader({
    super.key,
    required this.username,
    required this.gems,
    required this.ownedCards,
    required this.totalCards,
    required this.unopenedPacks,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalCards == 0 ? 0.0 : ownedCards / totalCards;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF3A50D0), AppColors.indigo, Color.lerp(AppColors.indigo, AppColors.ink, 0.5)!],
        ),
        boxShadow: [BoxShadow(color: AppColors.indigo.withValues(alpha: 0.35), blurRadius: 28, offset: const Offset(0, 14))],
      ),
      child: Column(
        spacing: 20,
        children: [
          Row(
            spacing: 14,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                child: Text(
                  username.isEmpty ? '?' : username[0].toUpperCase(),
                  style: const TextStyle(color: AppColors.indigo, fontSize: 20, fontWeight: .w900),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text('Welcome back', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13)),
                    Text(
                      'Hi, $username',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: .w900),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: _Stat(
                  label: 'Collected',
                  value: '$ownedCards/$totalCards',
                  leading: SizedBox.square(
                    dimension: 22,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 3.5,
                      color: AppColors.legendary,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _Stat(
                  label: 'Packs',
                  value: '$unopenedPacks',
                  leading: const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
                ),
              ),
              Expanded(
                child: _Stat(
                  label: 'Gems',
                  value: '$gems',
                  leading: const Icon(Icons.diamond, color: Color(0xFF8FC3FF), size: 22),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Widget leading;

  const _Stat({required this.label, required this.value, required this.leading});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 8,
        children: [
          leading,
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: .w900)),
          Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
        ],
      ),
    );
  }
}
