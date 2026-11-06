import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/format/formatters.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/time/clock.dart';
import 'package:mobile/features/game/data/game_repository.dart';
import 'package:mobile/features/game/domain/portfolio.dart';
import 'package:mobile/features/game/domain/trading.dart';
import 'package:mobile/features/game/presentation/sheets/order_form.dart';

Future<void> showSellSheet(BuildContext context, Portfolio portfolio, Holding holding) =>
    showOrderSheet(context, _SellSheet(portfolio: portfolio, holding: holding));

class _SellSheet extends ConsumerWidget {
  final Portfolio portfolio;
  final Holding holding;

  const _SellSheet({required this.portfolio, required this.holding});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final position = holding.position;
    final symbol = holding.asset.symbol;

    return OrderForm(
      asset: holding.asset,
      month: portfolio.month,
      details: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            _ValueLine(label: 'You hold', value: '${formatQuantity(position.quantity)} $symbol'),
            _ValueLine(label: 'Average buy price', value: formatPrice(position.averagePrice)),
            _ValueLine(
              label: 'Gain',
              value: '${formatSignedMoney(holding.gain)} (${formatPercent(holding.gainPercent)})',
              color: AppColors.trend(holding.gain),
            ),
          ],
        ),
      ),
      fieldLabel: 'Quantity to sell',
      shortcuts: {'Half': (position.quantity / 2).toString(), 'Everything': position.quantity.toString()},
      convert: (quantity, price) => sellProceeds(quantity: quantity, held: position.quantity, price: price),
      describe: (proceeds) => 'You will receive ≈ ${formatMoney(proceeds)}',
      submitLabel: 'Sell',
      submitColor: AppColors.negative,
      successMessage: 'You sold $symbol.',
      onSubmit: (quantity, price) => ref.read(gameRepositoryProvider).sell(
        gameId: portfolio.game.id,
        assetId: holding.asset.id,
        quantity: quantity,
        price: price,
        now: ref.read(clockProvider)(),
      ),
    );
  }
}

class _ValueLine extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _ValueLine({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: AppColors.muted))),
          Text(value, style: TextStyle(fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}
