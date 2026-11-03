import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/invest/domain/simulation.dart';
import 'package:mobile/features/invest/presentation/money_format.dart';

class ResultStats extends StatelessWidget {
  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  final SimulationResult result;

  const ResultStats({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final drawdownDate = result.maxDrawdownDate;
    final versusSavings = result.finalValue - result.savingsValue;

    final tiles = [
      _Stat(
        label: 'Money put in',
        value: formatEuros(result.invested),
        explanation: 'The total amount you would have paid: the starting amount plus every monthly contribution.',
      ),
      _Stat(
        label: 'Gain',
        value: formatPercent(result.gainPercent),
        color: AppColors.trend(result.gain >= 0),
        explanation: 'How much your money grew compared to what you put in. A negative gain means a loss.',
      ),
      _Stat(
        label: 'Yearly growth',
        value: formatPercent(result.annualizedReturn),
        color: AppColors.trend(result.annualizedReturn >= 0),
        explanation:
            'The average growth per year of the price. Growing 10 % per year does not mean +10 % every year: '
            'some years go up a lot, others go down, and this is the average pace.',
      ),
      _Stat(
        label: 'Worst drop',
        value: formatPercent(result.maxDrawdown),
        caption: drawdownDate == null ? 'No drop' : 'in ${_months[drawdownDate.month - 1]} ${drawdownDate.year}',
        color: result.maxDrawdown < 0 ? AppColors.negative : AppColors.positive,
        explanation:
            'The biggest fall from a previous high. It shows how scary the ride could have been: '
            'staying invested during drops is often what makes the final gain.',
      ),
      _Stat(
        label: 'vs savings account',
        value: formatEuros(versusSavings, signed: true),
        caption: 'Savings: ${formatEuros(result.savingsValue)}',
        color: AppColors.trend(versusSavings >= 0),
        explanation:
            'The difference with the same money left on a savings account paying 3 % per year. '
            'A savings account is safe but grows slowly; investing can grow more, with more risk.',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [for (final tile in tiles) SizedBox(width: tileWidth, child: tile)],
        );
      },
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final String? caption;
  final Color color;
  final String explanation;

  const _Stat({
    required this.label,
    required this.value,
    this.caption,
    this.color = AppColors.ink,
    required this.explanation,
  });

  void _explain(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          spacing: 12,
          children: [
            Text(label, style: Theme.of(context).textTheme.headlineMedium),
            Text(explanation, style: const TextStyle(fontSize: 16, height: 1.4)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _explain(context),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: .start,
            spacing: 4,
            children: [
              Row(
                children: [
                  Expanded(child: Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 13))),
                  const Icon(Icons.help_outline, size: 16, color: AppColors.muted),
                ],
              ),
              Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: .w900)),
              if (caption case final caption?)
                Text(caption, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
