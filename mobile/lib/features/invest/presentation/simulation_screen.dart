import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/network/api_error_message.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/app_network_image.dart';
import 'package:mobile/core/widgets/app_panel.dart';
import 'package:mobile/core/widgets/fade_slide_in.dart';
import 'package:mobile/features/cards/data/models/asset.dart';
import 'package:mobile/features/invest/domain/simulation.dart';
import 'package:mobile/features/invest/presentation/invest_providers.dart';
import 'package:mobile/features/invest/presentation/money_format.dart';
import 'package:mobile/features/invest/presentation/widgets/result_stats.dart';
import 'package:mobile/features/invest/presentation/widgets/simulation_chart.dart';

class SimulationScreen extends ConsumerStatefulWidget {
  final Asset card;

  const SimulationScreen({super.key, required this.card});

  @override
  ConsumerState<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends ConsumerState<SimulationScreen> {
  static const _durations = [1, 3, 5, 10];
  static const _amountPresets = [100.0, 500.0, 1000.0, 5000.0];
  static const _monthlyPresets = [0.0, 50.0, 100.0, 250.0];

  late final _amountController = TextEditingController(text: '1000');
  late final _monthlyController = TextEditingController(text: '0');
  int _years = 5;
  _Request? _request;

  double get _amount => double.tryParse(_amountController.text) ?? 0;

  double get _monthly => double.tryParse(_monthlyController.text) ?? 0;

  bool get _canSimulate => _amount > 0 || _monthly > 0;

  @override
  void dispose() {
    _amountController.dispose();
    _monthlyController.dispose();
    super.dispose();
  }

  void _setPreset(TextEditingController controller, double value) =>
      setState(() => controller.text = value.toStringAsFixed(0));

  void _simulate() {
    FocusScope.of(context).unfocus();
    setState(() => _request = _Request(amount: _amount, monthly: _monthly, years: _years));
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.card;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, title: const Text('Simulation')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          _AssetHeader(card: card),
          const SizedBox(height: 20),
          AppPanel(
            child: Column(
              crossAxisAlignment: .start,
              spacing: 12,
              children: [
                const _Label(title: 'Starting amount', subtitle: 'Invested on the first day'),
                _MoneyField(controller: _amountController, onChanged: () => setState(() {})),
                _Presets(
                  values: _amountPresets,
                  selected: _amount,
                  onSelected: (value) => _setPreset(_amountController, value),
                ),
                const SizedBox(height: 8),
                const _Label(title: 'Duration', subtitle: 'How long ago you would have started'),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<int>(
                    showSelectedIcon: false,
                    segments: [
                      for (final years in _durations)
                        ButtonSegment(value: years, label: Text('$years ${years == 1 ? 'year' : 'years'}')),
                    ],
                    selected: {_years},
                    onSelectionChanged: (selection) => setState(() => _years = selection.first),
                  ),
                ),
                const SizedBox(height: 8),
                const _Label(title: 'Monthly contribution', subtitle: 'Added at the start of every month (optional)'),
                _MoneyField(controller: _monthlyController, onChanged: () => setState(() {})),
                _Presets(
                  values: _monthlyPresets,
                  selected: _monthly,
                  onSelected: (value) => _setPreset(_monthlyController, value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _canSimulate ? _simulate : null,
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Run the simulation'),
          ),
          if (_request case final request?) ...[
            const SizedBox(height: 24),
            _ResultPreview(card: card, request: request),
          ],
        ],
      ),
    );
  }
}

class _Request {
  final double amount;
  final double monthly;
  final int years;

  const _Request({required this.amount, required this.monthly, required this.years});
}

class _AssetHeader extends StatelessWidget {
  final Asset card;

  const _AssetHeader({required this.card});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 14,
      children: [
        AppNetworkImage(url: card.logoUrl, size: 56),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            spacing: 2,
            children: [
              Text(card.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: .w900)),
              Text('${card.symbol} · ${card.type}', style: const TextStyle(color: AppColors.muted)),
            ],
          ),
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  final String title;
  final String subtitle;

  const _Label({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: .w800)),
        Text(subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
      ],
    );
  }
}

class _MoneyField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const _MoneyField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (_) => onChanged(),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(7)],
      style: const TextStyle(fontSize: 20, fontWeight: .w800),
      decoration: const InputDecoration(suffixText: '€'),
    );
  }
}

class _Presets extends StatelessWidget {
  final List<double> values;
  final double selected;
  final ValueChanged<double> onSelected;

  const _Presets({required this.values, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final value in values)
          ChoiceChip(
            label: Text(formatEuros(value)),
            selected: value == selected,
            onSelected: (_) => onSelected(value),
          ),
      ],
    );
  }
}

class _ResultPreview extends ConsumerWidget {
  final Asset card;
  final _Request request;

  const _ResultPreview({required this.card, required this.request});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(monthlyHistoryProvider((card.id, request.years))).when(
      loading: () => const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator())),
      error: (error, stackTrace) => Text(apiErrorMessage(error), textAlign: .center),
      data: (prices) {
        final result = simulate(prices: prices, amount: request.amount, monthlyContribution: request.monthly);

        return Column(
          crossAxisAlignment: .stretch,
          spacing: 16,
          children: [
            FadeSlideIn(
              child: AppPanel(
                child: Column(
                  spacing: 6,
                  children: [
                    Text(
                      'After ${request.years} ${request.years == 1 ? 'year' : 'years'}, you would have',
                      style: const TextStyle(color: AppColors.muted),
                    ),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: result.invested, end: result.finalValue),
                      duration: const Duration(milliseconds: 1200),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, _) => Text(formatEuros(value), style: Theme.of(context).textTheme.displaySmall),
                    ),
                    Text(
                      '${formatEuros(result.gain, signed: true)} (${formatPercent(result.gainPercent)}) on ${formatEuros(result.invested)} put in',
                      textAlign: .center,
                      style: TextStyle(color: AppColors.trend(result.gain >= 0), fontWeight: .w800),
                    ),
                  ],
                ),
              ),
            ),
            FadeSlideIn(index: 1, child: AppPanel(child: SimulationChart(result: result))),
            FadeSlideIn(index: 2, child: ResultStats(result: result)),
            const Text(
              'Prices are sample data for now. Tap a tile to learn what it means.',
              textAlign: .center,
              style: TextStyle(color: AppColors.muted, fontSize: 12),
            ),
          ],
        );
      },
    );
  }
}
