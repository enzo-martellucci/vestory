import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/features/cards/data/models/rarity.dart';
import 'package:mobile/features/player/data/models/pack.dart';
import 'package:mobile/features/player/presentation/pack_opening/pack_opening_screen.dart';
import 'package:mobile/features/player/presentation/pack_opening/rarity_effects.dart';
import 'package:mobile/features/player/presentation/widgets/pack_visual.dart';

class OpeningPack extends StatefulWidget {
  static const shakeDuration = Duration(milliseconds: 1400);
  static const burstDuration = Duration(milliseconds: 900);
  static const holdDuration = Duration(milliseconds: 1100);
  static const width = 200.0;
  static const _tearShare = 0.2;

  final PackType type;
  final Rarity? rarity;
  final OpeningPhase phase;
  final VoidCallback onHoldComplete;
  final VoidCallback onBurstComplete;

  const OpeningPack({
    super.key,
    required this.type,
    required this.rarity,
    required this.phase,
    required this.onHoldComplete,
    required this.onBurstComplete,
  });

  @override
  State<OpeningPack> createState() => _OpeningPackState();
}

class _OpeningPackState extends State<OpeningPack> with TickerProviderStateMixin {
  late final _arrive = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..forward();
  late final _float = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400))..repeat();
  late final _wobble = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
  late final _hold = AnimationController(vsync: this, duration: OpeningPack.holdDuration)
    ..addStatusListener(_onHoldStatus);
  late final _shake = AnimationController(vsync: this, duration: OpeningPack.shakeDuration);
  late final _charge = AnimationController(vsync: this);
  late final _burst = AnimationController(vsync: this, duration: OpeningPack.burstDuration);

  bool get _canHold => widget.phase == OpeningPhase.ready && _arrive.isCompleted;

  void _onHoldStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed)
      return;
    HapticFeedback.mediumImpact();
    widget.onHoldComplete();
  }

  void _startHold() {
    if (!_canHold)
      return;
    HapticFeedback.selectionClick();
    _hold.forward();
  }

  void _releaseHold() {
    if (widget.phase == OpeningPhase.ready && !_hold.isCompleted)
      _hold.reverse();
  }

  @override
  void didUpdateWidget(OpeningPack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.phase == widget.phase)
      return;

    switch (widget.phase) {
      case OpeningPhase.ready:
        _hold.reset();
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
    _arrive.dispose();
    _float.dispose();
    _wobble.dispose();
    _hold.dispose();
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

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _startHold(),
      onTapUp: (_) => _releaseHold(),
      onTapCancel: _releaseHold,
      child: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([_arrive, _float, _wobble, _hold, _shake, _charge, _burst]),
          builder: (context, _) {
            final arrive = Curves.bounceOut.transform(_arrive.value);
            final burst = _burst.value;
            final tear = Curves.easeOut.transform((burst / 0.45).clamp(0.0, 1.0));
            final explode = Curves.easeOut.transform(((burst - 0.35) / 0.65).clamp(0.0, 1.0));
            final charge = _charge.value;
            final hold = _hold.value;
            final intensity = widget.phase == OpeningPhase.burst ? 0.0 : hold * 0.5 + _shake.value + charge * legendaryBoost;
            final wobble = _wobble.value * math.pi * 2;
            final floatY = widget.phase == OpeningPhase.ready ? math.sin(_float.value * 2 * math.pi) * 8 * (1 - hold) : 0.0;
            final shakeX = math.sin(wobble * 11) * 10 * intensity;
            final shakeAngle = math.sin(wobble * 9) * 0.1 * intensity;
            final auraAlpha = math.max(charge * (rarity?.glowStrength ?? 0), hold * 0.5) * (1 - explode);
            const height = OpeningPack.width / PackVisual.aspectRatio;

            return Stack(
              alignment: .center,
              clipBehavior: .none,
              children: [
                if (auraAlpha > 0)
                  _Glow(color: auraColor, size: OpeningPack.width * (1.8 + 0.4 * math.sin(wobble * 3)), alpha: auraAlpha),
                if (explode > 0)
                  _Glow(color: auraColor, size: OpeningPack.width * (1 + 3.5 * explode), alpha: 1 - explode, core: Colors.white),
                if (widget.phase == OpeningPhase.ready && hold > 0)
                  CustomPaint(size: const Size.square(height * 1.25), painter: _HoldRingPainter(hold, auraColor)),
                Opacity(
                  opacity: (1 - explode) * _arrive.value.clamp(0, 1),
                  child: Transform.translate(
                    offset: Offset(shakeX, floatY - (1 - arrive) * 420),
                    child: Transform.rotate(
                      angle: shakeAngle,
                      child: Transform.scale(
                        scale: 1 + 0.6 * explode,
                        child: Column(
                          mainAxisSize: .min,
                          children: [
                            Transform.translate(
                              offset: Offset(tear * 70, -tear * 160),
                              child: Transform.rotate(
                                angle: tear * 0.9,
                                child: Opacity(opacity: 1 - tear, child: _PackPart(type: widget.type, top: true)),
                              ),
                            ),
                            _PackPart(type: widget.type, top: false),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PackPart extends StatelessWidget {
  final PackType type;
  final bool top;

  const _PackPart({required this.type, required this.top});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Align(
        alignment: top ? Alignment.topCenter : Alignment.bottomCenter,
        heightFactor: top ? OpeningPack._tearShare : 1 - OpeningPack._tearShare,
        child: PackVisual(type: type, width: OpeningPack.width),
      ),
    );
  }
}

class _HoldRingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _HoldRingPainter(this.progress, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final track = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    final arc = Paint()
      ..color = Color.lerp(Colors.white, color, 0.3)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawOval(rect.deflate(3), track);
    canvas.drawArc(rect.deflate(3), -math.pi / 2, progress * 2 * math.pi, false, arc);
  }

  @override
  bool shouldRepaint(_HoldRingPainter oldDelegate) => oldDelegate.progress != progress || oldDelegate.color != color;
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
