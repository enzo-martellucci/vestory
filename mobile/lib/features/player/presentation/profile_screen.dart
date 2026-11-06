import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/format/formatters.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/core/widgets/page_insets.dart';
import 'package:mobile/core/widgets/panel.dart';
import 'package:mobile/features/assets/domain/rarity.dart';
import 'package:mobile/features/assets/presentation/asset_providers.dart';
import 'package:mobile/features/assets/presentation/asset_style.dart';
import 'package:mobile/features/game/domain/game_rules.dart';
import 'package:mobile/features/game/presentation/game_providers.dart';
import 'package:mobile/features/player/data/player_repository.dart';
import 'package:mobile/features/player/presentation/player_providers.dart';

class ProfileScreen extends ConsumerWidget {
  static const _debugGems = 10000;

  const ProfileScreen({super.key});

  Future<void> _reset(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset everything?'),
        content: const Text('Your cards, packs, gems and games will be deleted. This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.negative),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (confirmed == true)
      await ref.read(playerRepositoryProvider).reset();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider).value;
    final assets = ref.watch(assetsProvider).value ?? const [];
    final games = ref.watch(finishedGamesProvider).value ?? const [];
    if (player == null)
      return const SizedBox.shrink();

    final owned = assets.where((asset) => asset.quantity > 0).toList();
    final best = bestPerformance(games);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: pageInsets(context),
        children: [
          Panel(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.primary,
                  child: Text(player.username[0].toUpperCase(), style: AppTheme.display(26, color: Colors.white)),
                ),
                const SizedBox(width: 16),
                Expanded(child: Text(player.username, style: AppTheme.display(24))),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            padding: EdgeInsets.zero,
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.7,
            children: [
              _Stat(icon: Icons.style_rounded, label: 'Cards', value: '${owned.length} / ${assets.length}', color: AppColors.primary),
              _Stat(icon: Icons.diamond_rounded, label: 'Gems', value: formatGems(player.gems), color: AppColors.gem),
              _Stat(icon: Icons.flag_rounded, label: 'Games played', value: '${games.length}', color: AppColors.gold),
              _Stat(
                icon: Icons.emoji_events_rounded,
                label: 'Best game',
                value: best == null ? '—' : formatPercent(best),
                color: best == null ? AppColors.muted : AppColors.trend(best),
              ),
            ],
          ),
          const SectionHeader('Cards by rarity'),
          Panel(
            child: Column(
              children: [
                for (final rarity in Rarity.values.reversed)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: _RarityProgress(
                      rarity: rarity,
                      owned: owned.where((asset) => asset.rarity == rarity).length,
                      total: assets.where((asset) => asset.rarity == rarity).length,
                    ),
                  ),
              ],
            ),
          ),
          const SectionHeader('Settings'),
          if (kDebugMode) ...[
            OutlinedButton.icon(
              onPressed: () => ref.read(playerRepositoryProvider).addGems(_debugGems),
              icon: const Icon(Icons.diamond_rounded),
              label: Text('Add ${formatGems(_debugGems)} gems (debug)'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => ref.read(playerRepositoryProvider).resetDailyPack(),
              icon: const Icon(Icons.card_giftcard_rounded),
              label: const Text('Reset daily pack (debug)'),
            ),
            const SizedBox(height: 12),
          ],
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.negative),
            onPressed: () => _reset(context, ref),
            icon: const Icon(Icons.restart_alt_rounded),
            label: const Text('Reset my progress'),
          ),
          const SizedBox(height: 12),
          Text(
            'Games last $gameDurationMonths months and start with ${formatMoney(initialCash)}. Market data by Twelve Data.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _Stat({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Panel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: AppTheme.display(20, color: color == AppColors.muted ? AppColors.ink : color)),
              Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _RarityProgress extends StatelessWidget {
  final Rarity rarity;
  final int owned;
  final int total;

  const _RarityProgress({required this.rarity, required this.owned, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 86, child: Text(rarity.label, style: TextStyle(color: rarity.color, fontWeight: FontWeight.w700))),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : owned / total,
              minHeight: 8,
              color: rarity.color,
              backgroundColor: rarity.color.withValues(alpha: 0.12),
            ),
          ),
        ),
        SizedBox(width: 56, child: Text('$owned/$total', textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.w600))),
      ],
    );
  }
}
