import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/core/format/formatters.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/core/time/year_month.dart';
import 'package:mobile/core/widgets/panel.dart';
import 'package:mobile/features/assets/presentation/asset_logo.dart';
import 'package:mobile/features/game/domain/trading.dart';
import 'package:mobile/features/market/presentation/market_providers.dart';

Future<void> showOrderSheet(BuildContext context, Widget child) => showModalBottomSheet(
  context: context,
  useRootNavigator: true,
  isScrollControlled: true,
  builder: (context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    child: ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.85),
      child: child,
    ),
  ),
);

class OrderForm extends ConsumerStatefulWidget {
  final Asset asset;
  final YearMonth month;
  final Widget? headerAction;
  final Widget? details;
  final String fieldLabel;
  final String? fieldPrefix;
  final String? fieldHelper;
  final Map<String, String> shortcuts;
  final double Function(double input, double? price) convert;
  final String Function(double converted) describe;
  final String submitLabel;
  final Color? submitColor;
  final String successMessage;
  final Future<void> Function(double input, double price) onSubmit;

  const OrderForm({
    super.key,
    required this.asset,
    required this.month,
    this.headerAction,
    this.details,
    required this.fieldLabel,
    this.fieldPrefix,
    this.fieldHelper,
    required this.shortcuts,
    required this.convert,
    required this.describe,
    required this.submitLabel,
    this.submitColor,
    required this.successMessage,
    required this.onSubmit,
  });

  @override
  ConsumerState<OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends ConsumerState<OrderForm> {
  final _formKey = GlobalKey<FormState>();
  final _input = TextEditingController();
  var _submitting = false;

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  double? get _value => double.tryParse(_input.text.trim().replaceAll(',', '.'));

  String? _validate(double? price) {
    final value = _value;
    if (value == null)
      return 'Enter a valid number.';
    try {
      widget.convert(value, price);
      return null;
    } on TradeException catch (exception) {
      return exception.message;
    }
  }

  Future<void> _submit(double price) async {
    if (!_formKey.currentState!.validate())
      return;

    setState(() => _submitting = true);
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await widget.onSubmit(_value!, price);
      navigator.pop();
      messenger.showSnackBar(SnackBar(content: Text(widget.successMessage)));
    } catch (error) {
      setState(() => _submitting = false);
      messenger.showSnackBar(SnackBar(content: Text('$error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(priceHistoryProvider(widget.asset.id));
    final price = history.value?.priceAt(widget.month);
    final isValid = _input.text.isNotEmpty && _validate(price) == null;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OrderAssetHeader(asset: widget.asset, action: widget.headerAction),
            const SizedBox(height: 16),
            Panel(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  history.when(
                    loading: () => const SizedBox(height: 48, child: Center(child: CircularProgressIndicator())),
                    error: (error, _) => ErrorView(error: error, onRetry: () => ref.invalidate(priceHistoryProvider(widget.asset.id))),
                    data: (history) => price == null
                        ? Text(
                            history.firstMonth == null
                                ? 'No price history for this asset.'
                                : '${widget.asset.symbol} was not listed yet in ${widget.month.label}. It starts trading in ${history.firstMonth!.label}.',
                            style: const TextStyle(color: AppColors.muted),
                          )
                        : Row(
                            children: [
                              Expanded(child: Text('Price in ${widget.month.label}', style: const TextStyle(color: AppColors.muted))),
                              Text(formatPrice(price), style: AppTheme.display(20)),
                            ],
                          ),
                  ),
                  ?widget.details,
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _input,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,e-]'))],
              decoration: InputDecoration(labelText: widget.fieldLabel, prefixText: widget.fieldPrefix, helperText: widget.fieldHelper),
              validator: (_) => _validate(price),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                for (final shortcut in widget.shortcuts.entries)
                  ActionChip(label: Text(shortcut.key), onPressed: () => setState(() => _input.text = shortcut.value)),
              ],
            ),
            if (isValid) ...[
              const SizedBox(height: 12),
              Text(widget.describe(widget.convert(_value!, price)), style: const TextStyle(color: AppColors.muted)),
            ],
            const SizedBox(height: 20),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: widget.submitColor),
              onPressed: _submitting || price == null ? null : () => _submit(price),
              child: Text(widget.submitLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderAssetHeader extends StatelessWidget {
  final Asset asset;
  final Widget? action;

  const OrderAssetHeader({super.key, required this.asset, this.action});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AssetLogo(asset: asset, size: 48),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(asset.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTheme.display(18)),
              Text(asset.symbol, style: const TextStyle(color: AppColors.muted)),
            ],
          ),
        ),
        ?action,
      ],
    );
  }
}
