import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:mobile/features/cards/data/models/card_rarity.dart';
import 'package:mobile/features/player/data/models/pack_type.dart';
import 'package:mobile/features/player/presentation/pack_opening/opening_phase.dart';
import 'package:mobile/features/player/presentation/pack_opening/rarity_effects.dart';
import 'package:mobile/features/player/presentation/widgets/pack_visual.dart';

class OpeningPack extends StatefulWidget {
  static const shakeDuration = Duration(milliseconds: 800);
  static const burstDuration = Duration(milliseconds: 450);
  static const width = 200.0;

  final PackType type;
  final CardRarity? rarity;
  final OpeningPhase phase;
  final VoidCallback onBurstComplete;

  const OpeningPack({
    super.key,
    required this.type,
    required this.rarity,
    required this.phase,
    required this.onBurstComplete,
  });

  @override
  State<OpeningPack> createState() => _OpeningPackState();
}

class _OpeningPackState extends State<OpeningPack> with TickerProviderStateMixin {
  late final _float = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))
    ..repeat(reverse: true);
  late final _wobble = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
  late final _shake = AnimationController(vsync: this, duration: OpeningPack.shakeDuration);
  late final _charge = AnimationController(vsync: this);
  late final _burst = AnimationController(vsync: this, duration: OpeningPack.burstDuration);

  @override
  void didUpdateWidget(OpeningPack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.phase == widget.phase)
      return;

    switch (widget.phase) {
      case OpeningPhase.ready:
        _shake.reset();
        _charge.reset();
        _burst.reset();
      case OpeningPhase.shaking:
        _shake.forward(from: 0);
      case OpeningPhase.charging:
        final duration = widget.rarity!.chargeDuration;
        if (duration > Duration.zero)
          _charge
            ..duration = duration
            ..forward(from: 0);
      case OpeningPhase.burst:
        _burst.forward(from: 0).then((_) => widget.onBurstComplete());
      default:
    }
  }

  @override
  void dispose() {
    _float.dispose();
    _wobble.dispose();
    _shake.dispose();
    _charge.dispose();
    _burst.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rarity = widget.rarity;
    final auraColor = rarity?.color ?? PackVisual.colorOf(widget.type);
    final legendaryBoost = (rarity?.isLegendary ?? false) ? 1.0 : 0.4;

    return AnimatedBuilder(
      animation: Listenable.merge([_float, _wobble, _shake, _charge, _burst]),
      builder: (context, child) {
        final burst = Curves.easeOut.transform(_burst.value);
        final charge = _charge.value;
        final intensity = widget.phase == OpeningPhase.burst ? 0.0 : _shake.value + charge * legendaryBoost;
        final wobble = _wobble.value * math.pi * 2;
        final floatY = widget.phase == OpeningPhase.ready ? (_float.value - 0.5) * 16 : 0.0;
        final shakeX = math.sin(wobble * 11) * 10 * intensity;
        final shakeAngle = math.sin(wobble * 9) * 0.1 * intensity;
        final auraAlpha = charge * (rarity?.glowStrength ?? 0) * (1 - burst);
        final flashSize = OpeningPack.width * (1 + 3 * burst);

        return Stack(
          alignment: .center,
          clipBehavior: .none,
          children: [
            if (auraAlpha > 0)
              _Glow(color: auraColor, size: OpeningPack.width * (1.8 + 0.4 * math.sin(wobble * 3)), alpha: auraAlpha),
            if (_burst.value > 0)
              _Glow(color: auraColor, size: flashSize, alpha: 1 - burst, core: Colors.white),
            Opacity(
              opacity: 1 - burst,
              child: Transform.translate(
                offset: Offset(shakeX, floatY),
                child: Transform.rotate(
                  angle: shakeAngle,
                  child: Transform.scale(scale: 1 + 0.6 * burst, child: child),
                ),
              ),
            ),
          ],
        );
      },
      child: PackVisual(type: widget.type, width: OpeningPack.width),
    );
  }
}

class _Glow extends StatelessWidget {
  final Color color;
  final double size;
  final double alpha;
  final Color? core;

  const _Glow({required this.color, required this.size, required this.alpha, this.core});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: OverflowBox(
        maxWidth: double.infinity,
        maxHeight: double.infinity,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                (core ?? color).withValues(alpha: alpha * 0.9),
                color.withValues(alpha: alpha * 0.4),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
