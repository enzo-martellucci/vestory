import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/format/formatters.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/core/widgets/animated_number.dart';
import 'package:mobile/core/widgets/panel.dart';
import 'package:mobile/features/game/domain/game_rules.dart';
import 'package:mobile/features/game/domain/portfolio.dart';

class GameHeader extends StatelessWidget {
  final Portfolio portfolio;

  const GameHeader({super.key, required this.portfolio});

  @override
  Widget build(BuildContext context) {
    return Panel(
      gradient: const LinearGradient(colors: [AppColors.ink, AppColors.inkSoft], begin: Alignment.topLeft, end: Alignment.bottomRight),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_month_rounded, color: Colors.white70, size: 18),
              const SizedBox(width: 6),
              Text(portfolio.month.label, style: AppTheme.display(18, color: Colors.white)),
              const Spacer(),
              Text(
                'Month ${portfolio.elapsedMonths + 1} of $gameDurationMonths',
                style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: (portfolio.elapsedMonths + 1) / gameDurationMonths,
              minHeight: 6,
              backgroundColor: Colors.white12,
              color: AppColors.gold,
            ),
          ),
          const SizedBox(height: 20),
          const Text('Total value', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AnimatedNumber(value: portfolio.totalValue, format: formatMoney, style: AppTheme.display(34, color: Colors.white)),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.trend(portfolio.performance), borderRadius: BorderRadius.circular(999)),
                  child: Text(formatPercent(portfolio.performance), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _Stat(label: 'Cash', value: formatMoney(portfolio.cash))),
              Expanded(child: _Stat(label: 'Invested', value: formatMoney(portfolio.holdingsValue))),
              Expanded(child: _Stat(label: 'Months left', value: '${portfolio.remainingMonths}')),
            ],
          ),
          const SizedBox(height: 14),
          const Text('A new month starts every day at midnight.', style: TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;

  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ],
    );
  }
}
