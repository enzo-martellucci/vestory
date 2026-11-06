import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/core/format/formatters.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/core/time/clock.dart';
import 'package:mobile/core/widgets/page_insets.dart';
import 'package:mobile/core/widgets/panel.dart';
import 'package:mobile/features/game/data/game_repository.dart';
import 'package:mobile/features/game/domain/game_rules.dart';
import 'package:mobile/features/game/presentation/game_providers.dart';
import 'package:mobile/features/market/domain/price_history.dart';

class NoGameView extends ConsumerWidget {
  const NoGameView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(finishedGamesProvider).value ?? const [];
    final best = bestPerformance(games);

    return ListView(
      padding: pageInsets(context),
      children: [
        if (games.isNotEmpty) ...[
          _GameResult(game: games.first, isLast: true),
          const SizedBox(height: 16),
        ],
        Panel(
          gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF3A2BC9)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.history_toggle_off_rounded, color: Colors.white, size: 36),
              const SizedBox(height: 12),
              Text('Invest back in time', style: AppTheme.display(26, color: Colors.white)),
              const SizedBox(height: 12),
              for (final rule in [
                'You land on a random month between ${historyStartMonth.year} and ${gameDurationMonths ~/ 12} years ago.',
                'You start with ${formatMoney(initialCash)} of cash.',
                'Every real day, the market moves forward one month.',
                'Buy and sell the assets of your collection for $gameDurationMonths months.',
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(padding: EdgeInsets.only(top: 2), child: Icon(Icons.check_circle_rounded, color: Colors.white70, size: 16)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(rule, style: const TextStyle(color: Colors.white, height: 1.35))),
                    ],
                  ),
                ),
              const SizedBox(height: 12),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary),
                onPressed: () => ref.read(gameRepositoryProvider).start(ref.read(clockProvider)()),
                child: Text(games.isEmpty ? 'Start a game' : 'Start a new game'),
              ),
            ],
          ),
        ),
        if (games.length > 1) ...[
          SectionHeader('Past games', trailing: Text('Best ${formatPercent(best!)}', style: const TextStyle(color: AppColors.muted))),
          for (final game in games.skip(1)) ...[
            _GameResult(game: game),
            const SizedBox(height: 10),
          ],
        ],
      ],
    );
  }
}

class _GameResult extends StatelessWidget {
  final Game game;
  final bool isLast;

  const _GameResult({required this.game, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    final performance = game.performance ?? 0;
    final months = game.elapsedMonths(game.endedAt!);
    final period = '${game.startMonth.label} → ${game.startMonth.plus(months).label}';

    return Panel(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: AppColors.trend(performance).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
            child: Icon(performance >= 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded, color: AppColors.trend(performance)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isLast ? 'Last game' : period, style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(isLast ? '$period · $months months' : '$months months', style: const TextStyle(color: AppColors.muted, fontSize: 13)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(formatMoney(game.finalValue ?? initialCash), style: const TextStyle(fontWeight: FontWeight.w800)),
              Text(formatPercent(performance), style: TextStyle(color: AppColors.trend(performance), fontWeight: FontWeight.w700, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}
