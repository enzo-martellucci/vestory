import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/format/formatters.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/core/widgets/gem_badge.dart';
import 'package:mobile/core/widgets/page_insets.dart';
import 'package:mobile/core/widgets/panel.dart';
import 'package:mobile/features/assets/domain/rarity.dart';
import 'package:mobile/features/assets/presentation/asset_style.dart';
import 'package:mobile/features/packs/domain/pack_type.dart';
import 'package:mobile/features/packs/presentation/pack_art.dart';
import 'package:mobile/features/player/presentation/player_providers.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gems = ref.watch(playerProvider).value?.gems ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        actions: [Padding(padding: const EdgeInsets.only(right: 20), child: GemBadge(gems: gems))],
      ),
      body: ListView(
        padding: pageInsets(context),
        children: [
          const Text(
            'Earn gems with duplicates, then spend them on bigger packs.',
            style: TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 16),
          for (final type in PackType.values) ...[
            _Offer(type: type, affordable: gems >= type.price, onBuy: () => context.push('/open/${type.name}')),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

class _Offer extends StatelessWidget {
  final PackType type;
  final bool affordable;
  final VoidCallback onBuy;

  const _Offer({required this.type, required this.affordable, required this.onBuy});

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: Row(
        children: [
          PackArt(type: type, width: 86),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${type.label} pack', style: AppTheme.display(18)),
                const SizedBox(height: 10),
                _OddsBar(type: type),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 4,
                  children: [
                    for (final rarity in Rarity.values)
                      if (type.oddsOf(rarity) > 0)
                        Text(
                          '${rarity.label} ${(type.oddsOf(rarity) * 100).round()}%',
                          style: TextStyle(fontSize: 11, color: rarity.color, fontWeight: FontWeight.w700),
                        ),
                  ],
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: affordable ? onBuy : null,
                  icon: const Icon(Icons.diamond_rounded, size: 18),
                  label: Text(formatGems(type.price)),
                  style: FilledButton.styleFrom(minimumSize: const Size(0, 42)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OddsBar extends StatelessWidget {
  final PackType type;

  const _OddsBar({required this.type});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 8,
        child: Row(
          children: [
            for (final rarity in Rarity.values)
              if (type.oddsOf(rarity) > 0)
                Expanded(flex: (type.oddsOf(rarity) * 1000).round(), child: ColoredBox(color: rarity.color)),
          ],
        ),
      ),
    );
  }
}
