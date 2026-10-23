import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/widgets/app_network_image.dart';
import 'package:mobile/features/cards/data/models/asset_card_model.dart';
import 'package:mobile/features/player/presentation/pack_opening/rarity_effects.dart';

class WalkoutSequence extends StatefulWidget {
  final AssetCardModel card;
  final VoidCallback onComplete;

  const WalkoutSequence({super.key, required this.card, required this.onComplete});

  @override
  State<WalkoutSequence> createState() => _WalkoutSequenceState();
}

class _WalkoutSequenceState extends State<WalkoutSequence> {
  static const _countryNames = {
    'US': 'United States',
    'CH': 'Switzerland',
    'IE': 'Ireland',
    'GB': 'United Kingdom',
    'FR': 'France',
    'DE': 'Germany',
    'NL': 'Netherlands',
    'JP': 'Japan',
    'CN': 'China',
    'CA': 'Canada',
  };

  late final List<Widget> _steps = _buildSteps();
  Timer? _timer;
  int _index = 0;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _schedule();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _schedule() => _timer = Timer(widget.card.rarity.walkoutStepDuration, _advance);

  void _advance() {
    if (_index == _steps.length - 1) {
      _complete();
      return;
    }
    setState(() => _index++);
    _schedule();
  }

  void _complete() {
    if (_completed)
      return;
    _completed = true;
    _timer?.cancel();
    widget.onComplete();
  }

  List<Widget> _buildSteps() {
    final card = widget.card;
    final rarity = card.rarity;
    final country = card.country?.trim().toUpperCase() ?? '';
    final sector = card.sector?.trim() ?? '';
    final logoUrl = card.logoUrl?.trim() ?? '';

    return [
      Text(
        rarity.apiValue,
        style: TextStyle(
          color: rarity.color,
          fontSize: 48,
          fontWeight: .w900,
          letterSpacing: 6,
          shadows: [Shadow(color: rarity.color, blurRadius: 24)],
        ),
      ),
      _Clue(
        caption: 'Asset type',
        title: card.assetType,
        visual: Icon(_assetTypeIcon(card.assetType), color: Colors.white, size: 88),
      ),
      if (country.length == 2)
        _Clue(
          caption: 'Country',
          title: _countryNames[country] ?? country,
          visual: Text(_flag(country), style: const TextStyle(fontSize: 88)),
        ),
      if (sector.isNotEmpty)
        _Clue(
          caption: 'Sector',
          title: sector,
          visual: const Icon(Icons.business_center, color: Colors.white, size: 88),
        ),
      if (logoUrl.isNotEmpty)
        _Clue(
          caption: 'Brand',
          title: '',
          visual: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: rarity.color.withValues(alpha: 0.6), blurRadius: 32, spreadRadius: 4)],
            ),
            child: AppNetworkImage(url: logoUrl, size: 140),
          ),
        ),
    ];
  }

  static IconData _assetTypeIcon(String assetType) => switch (assetType) {
    'STOCK' => Icons.show_chart,
    'ETF' => Icons.pie_chart,
    'CRYPTO' => Icons.currency_bitcoin,
    'FOREX' => Icons.currency_exchange,
    'COMMODITY' => Icons.oil_barrel,
    _ => Icons.help_outline,
  };

  static String _flag(String countryCode) =>
      String.fromCharCodes(countryCode.codeUnits.map((unit) => 0x1F1E6 + unit - 0x41));

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _complete,
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 450),
          reverseDuration: const Duration(milliseconds: 150),
          switchInCurve: const Interval(0.35, 1, curve: Curves.easeOutBack),
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween(begin: const Offset(0, 0.2), end: Offset.zero).animate(animation),
              child: ScaleTransition(scale: Tween(begin: 0.8, end: 1.0).animate(animation), child: child),
            ),
          ),
          child: KeyedSubtree(key: ValueKey(_index), child: _steps[_index]),
        ),
      ),
    );
  }
}

class _Clue extends StatelessWidget {
  final String caption;
  final String title;
  final Widget visual;

  const _Clue({required this.caption, required this.title, required this.visual});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      spacing: 16,
      children: [
        Text(
          caption.toUpperCase(),
          style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14, fontWeight: .w700, letterSpacing: 3),
        ),
        visual,
        if (title.isNotEmpty)
          Text(
            title,
            textAlign: .center,
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: .w900),
          ),
      ],
    );
  }
}
