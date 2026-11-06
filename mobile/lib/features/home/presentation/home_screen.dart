import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/core/format/formatters.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/core/time/clock.dart';
import 'package:mobile/core/widgets/gem_badge.dart';
import 'package:mobile/core/widgets/page_insets.dart';
import 'package:mobile/core/widgets/panel.dart';
import 'package:mobile/features/assets/presentation/asset_card.dart';
import 'package:mobile/features/market/presentation/asset_detail_sheet.dart';
import 'package:mobile/features/assets/presentation/asset_providers.dart';
import 'package:mobile/features/game/domain/game_rules.dart';
import 'package:mobile/features/game/presentation/game_providers.dart';
import 'package:mobile/features/packs/presentation/pack_art.dart';
import 'package:mobile/features/packs/domain/daily_pack.dart';
import 'package:mobile/features/player/presentation/player_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider).value;
    if (player == null)
      return const SizedBox.shrink();

    final recent = ref.watch(recentAssetsProvider).value ?? const [];
    final total = ref.watch(assetsProvider).value?.length ?? 0;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: pageInsets(context, top: 16),
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary,
                  child: Text(player.username[0].toUpperCase(), style: AppTheme.display(20, color: Colors.white)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Welcome back', style: TextStyle(color: AppColors.muted)),
                      Text(player.username, style: AppTheme.display(22)),
                    ],
                  ),
                ),
                GemBadge(gems: player.gems),
              ],
            ),
            const SizedBox(height: 20),
            _DailyPack(player: player),
            const SectionHeader('Investment game'),
            const _GameSummary(),
            if (recent.isNotEmpty) ...[
              SectionHeader('Recent cards', trailing: TextButton(onPressed: () => context.go('/collection'), child: const Text('See all'))),
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: recent.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) => SizedBox(
                    width: 140,
                    child: FlippableAssetCard(
                      key: ValueKey(recent[index].id),
                      asset: recent[index],
                      total: total,
                      onDetails: () => showAssetDetailSheet(context, recent[index]),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DailyPack extends ConsumerStatefulWidget {
  final Player player;

  const _DailyPack({required this.player});

  @override
  ConsumerState<_DailyPack> createState() => _DailyPackState();
}

class _DailyPackState extends ConsumerState<_DailyPack> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = ref.watch(clockProvider)();
    final available = isDailyPackAvailable(widget.player.lastDailyPackAt, now);

    return Panel(
      gradient: available
          ? const LinearGradient(colors: [AppColors.primary, Color(0xFF8A5CFF)], begin: Alignment.topLeft, end: Alignment.bottomRight)
          : null,
      child: Row(
        children: [
          const PackArt(type: dailyPackType, width: 64),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Daily pack', style: AppTheme.display(18, color: available ? Colors.white : AppColors.ink)),
                const SizedBox(height: 4),
                Text(
                  available ? 'A free pack is waiting for you!' : 'Next free pack in ${formatCountdown(nextDailyPackAt(now).difference(now))}',
                  style: TextStyle(color: available ? Colors.white70 : AppColors.muted),
                ),
                if (available) ...[
                  const SizedBox(height: 12),
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary, minimumSize: const Size(0, 40)),
                    onPressed: () => context.push('/open/daily'),
                    child: const Text('Claim'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GameSummary extends ConsumerWidget {
  const _GameSummary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolio = ref.watch(portfolioProvider).value;
    return Panel(
      onTap: () => context.go('/invest'),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.show_chart_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: portfolio == null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Travel back in time', style: TextStyle(fontWeight: FontWeight.w700)),
                      Text('Start a game and grow your first ${formatMoney(initialCash)}.', style: const TextStyle(color: AppColors.muted)),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(portfolio.month.label, style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text('${portfolio.remainingMonths} months left', style: const TextStyle(color: AppColors.muted)),
                    ],
                  ),
          ),
          if (portfolio != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(formatMoney(portfolio.totalValue), style: const TextStyle(fontWeight: FontWeight.w800)),
                Text(formatPercent(portfolio.performance), style: TextStyle(color: AppColors.trend(portfolio.performance), fontWeight: FontWeight.w700)),
              ],
            )
          else
            const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
        ],
      ),
    );
  }
}
