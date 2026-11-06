import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/core/format/formatters.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/core/time/clock.dart';
import 'package:mobile/features/assets/domain/asset_search.dart';
import 'package:mobile/features/assets/presentation/asset_logo.dart';
import 'package:mobile/features/assets/presentation/asset_providers.dart';
import 'package:mobile/features/game/data/game_repository.dart';
import 'package:mobile/features/game/domain/portfolio.dart';
import 'package:mobile/features/game/domain/trading.dart';
import 'package:mobile/features/game/presentation/sheets/order_form.dart';

Future<void> showBuySheet(BuildContext context, Portfolio portfolio) => showOrderSheet(context, _BuySheet(portfolio: portfolio));

class _BuySheet extends ConsumerStatefulWidget {
  final Portfolio portfolio;

  const _BuySheet({required this.portfolio});

  @override
  ConsumerState<_BuySheet> createState() => _BuySheetState();
}

class _BuySheetState extends ConsumerState<_BuySheet> {
  Asset? _asset;
  var _search = '';

  Widget _buildForm(Asset asset) {
    final portfolio = widget.portfolio;
    return OrderForm(
      asset: asset,
      month: portfolio.month,
      headerAction: TextButton(onPressed: () => setState(() => _asset = null), child: const Text('Change')),
      fieldLabel: 'Amount to invest',
      fieldPrefix: '\$ ',
      fieldHelper: 'Available cash: ${formatMoney(portfolio.cash)}',
      shortcuts: {
        for (final share in const [0.25, 0.5, 1.0])
          share == 1 ? 'All cash' : '${(share * 100).round()}%': (portfolio.cash * share).floor().toString(),
      },
      convert: (amount, price) => buyQuantity(amount: amount, cash: portfolio.cash, price: price),
      describe: (quantity) => '≈ ${formatQuantity(quantity)} ${asset.symbol}',
      submitLabel: 'Buy',
      successMessage: 'You bought ${asset.symbol}.',
      onSubmit: (amount, price) => ref.read(gameRepositoryProvider).buy(
        gameId: portfolio.game.id,
        asset: asset,
        amount: amount,
        price: price,
        now: ref.read(clockProvider)(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final asset = _asset;
    if (asset != null)
      return _buildForm(asset);

    final owned = ref.watch(ownedAssetsProvider).value ?? const [];
    final visible = owned.where((asset) => asset.matches(_search)).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Buy an asset', style: AppTheme.display(22)),
              const SizedBox(height: 4),
              const Text('You can only invest in cards from your collection.', style: TextStyle(color: AppColors.muted)),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(hintText: 'Search your collection', prefixIcon: Icon(Icons.search_rounded)),
                onChanged: (value) => setState(() => _search = value),
              ),
            ],
          ),
        ),
        Flexible(
          child: owned.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('Open packs to collect assets first.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted)),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                  itemCount: visible.length,
                  itemBuilder: (context, index) {
                    final asset = visible[index];
                    return ListTile(
                      leading: AssetLogo(asset: asset, size: 40),
                      title: Text(asset.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text('${asset.symbol} · ${asset.type.label}'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => setState(() => _asset = asset),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
