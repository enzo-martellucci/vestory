import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/features/assets/presentation/asset_logo.dart';
import 'package:mobile/features/assets/presentation/asset_style.dart';
import 'package:mobile/features/packs/presentation/opening/rarity_effects.dart';

class WalkoutSequence extends StatefulWidget {
  final Asset asset;
  final VoidCallback onComplete;

  const WalkoutSequence({super.key, required this.asset, required this.onComplete});

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
  var _index = 0;
  var _completed = false;

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

  void _schedule() => _timer = Timer(widget.asset.rarity.walkoutStepDuration, _advance);

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
    final asset = widget.asset;
    final rarity = asset.rarity;
    final country = asset.country?.trim().toUpperCase() ?? '';
    final sector = asset.sector?.trim() ?? '';

    return [
      Text(
        rarity.label.toUpperCase(),
        style: TextStyle(
          color: rarity.color,
          fontSize: 48,
          fontWeight: FontWeight.w900,
          letterSpacing: 6,
          shadows: [Shadow(color: rarity.color, blurRadius: 24)],
        ),
      ),
      _Clue(
        caption: 'Asset type',
        title: asset.type.label,
        visual: Icon(asset.type.icon, color: Colors.white, size: 88),
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
          visual: const Icon(Icons.business_center_rounded, color: Colors.white, size: 88),
        ),
      if (asset.logoUrl != null)
        _Clue(
          caption: 'Brand',
          visual: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(42),
              boxShadow: [BoxShadow(color: rarity.color.withValues(alpha: 0.6), blurRadius: 32, spreadRadius: 4)],
            ),
            child: AssetLogo(asset: asset, size: 140),
          ),
        ),
    ];
  }

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
  final String? title;
  final Widget visual;

  const _Clue({required this.caption, this.title, required this.visual});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        Text(
          caption.toUpperCase(),
          style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 3),
        ),
        visual,
        if (title != null)
          Text(
            title!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
          ),
      ],
    );
  }
}
