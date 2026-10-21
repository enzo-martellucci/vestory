import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:mobile/features/player/data/models/pack_type.dart';
import 'package:mobile/features/player/presentation/pack_opening/opening_phase.dart';
import 'package:mobile/features/player/presentation/widgets/pack_visual.dart';

class OpeningPack extends StatefulWidget {
  static const shakeDuration = Duration(milliseconds: 800);
  static const burstDuration = Duration(milliseconds: 450);
  static const width = 200.0;

  final PackType type;
  final OpeningPhase phase;
  final VoidCallback onBurstComplete;

  const OpeningPack({super.key, required this.type, required this.phase, required this.onBurstComplete});

  @override
  State<OpeningPack> createState() => _OpeningPackState();
}

class _OpeningPackState extends State<OpeningPack> with TickerProviderStateMixin {
  late final _float = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))
    ..repeat(reverse: true);
  late final _shake = AnimationController(vsync: this, duration: OpeningPack.shakeDuration);
  late final _burst = AnimationController(vsync: this, duration: OpeningPack.burstDuration);

  @override
  void didUpdateWidget(OpeningPack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.phase == widget.phase)
      return;

    switch (widget.phase) {
      case OpeningPhase.ready:
        _shake.reset();
        _burst.reset();
      case OpeningPhase.shaking:
        _shake.forward(from: 0);
      case OpeningPhase.burst:
        _burst.forward(from: 0).then((_) => widget.onBurstComplete());
      default:
    }
  }

  @override
  void dispose() {
    _float.dispose();
    _shake.dispose();
    _burst.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = PackVisual.colorOf(widget.type);

    return AnimatedBuilder(
      animation: Listenable.merge([_float, _shake, _burst]),
      builder: (context, child) {
        final shake = _shake.value;
        final burst = Curves.easeOut.transform(_burst.value);
        final floatY = widget.phase == OpeningPhase.ready ? (_float.value - 0.5) * 16 : 0.0;
        final shakeX = math.sin(shake * math.pi * 22) * 10 * shake;
        final shakeAngle = math.sin(shake * math.pi * 18) * 0.1 * shake;
        final flashSize = OpeningPack.width * (1 + 3 * burst);

        return Stack(
          alignment: .center,
          clipBehavior: .none,
          children: [
            if (_burst.value > 0)
              IgnorePointer(
                child: OverflowBox(
                  maxWidth: double.infinity,
                  maxHeight: double.infinity,
                  child: Container(
                    width: flashSize,
                    height: flashSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withValues(alpha: (1 - burst) * 0.9),
                          color.withValues(alpha: (1 - burst) * 0.4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
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
