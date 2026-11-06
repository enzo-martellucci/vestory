import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/core/widgets/shine_sweep.dart';
import 'package:mobile/features/assets/presentation/asset_card.dart';
import 'package:mobile/features/assets/presentation/asset_style.dart';
import 'package:mobile/features/packs/presentation/opening/rarity_effects.dart';

class CardReveal extends StatefulWidget {
  static const _width = 240.0;
  static const _borderRadius = BorderRadius.all(Radius.circular(30));

  final Asset asset;
  final int total;
  final VoidCallback onRevealed;
  final VoidCallback onDetails;

  const CardReveal({super.key, required this.asset, required this.total, required this.onRevealed, required this.onDetails});

  @override
  State<CardReveal> createState() => _CardRevealState();
}

class _CardRevealState extends State<CardReveal> with TickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: widget.asset.rarity.revealDuration);
  late final _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
  late final _appear = CurvedAnimation(parent: _controller, curve: const Interval(0, 0.35, curve: Curves.easeOutCubic));
  late final _flip = CurvedAnimation(parent: _controller, curve: const Interval(0.4, 1, curve: Curves.easeInOutCubic));
  var _revealed = false;

  @override
  void initState() {
    super.initState();
    _controller.forward().then((_) {
      if (!mounted)
        return;
      setState(() => _revealed = true);
      widget.onRevealed();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_controller, _pulse]),
      builder: (context, child) {
        final rarity = widget.asset.rarity;
        final appear = _appear.value.clamp(0.0, 1.0);
        final glow = rarity.glowStrength * (0.6 + 0.4 * _pulse.value) * (_flip.value > 0.5 ? 0.6 : 1);
        final beam = appear * (1 - _flip.value * 0.7);

        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -360,
              bottom: -360,
              left: CardReveal._width * 0.05,
              right: CardReveal._width * 0.05,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Color.lerp(rarity.color, Colors.white, 0.3)!.withValues(alpha: 0.5 * beam),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: CardReveal._width,
              decoration: BoxDecoration(
                borderRadius: CardReveal._borderRadius,
                boxShadow: [
                  if (glow > 0)
                    BoxShadow(
                      color: rarity.color.withValues(alpha: glow * appear),
                      blurRadius: 24 + 32 * glow,
                      spreadRadius: 2 + 10 * glow,
                    ),
                ],
              ),
              child: _revealed ? child : _buildFlip(),
            ),
          ],
        );
      },
      child: ShineSweep(
        borderRadius: CardReveal._borderRadius,
        child: FlippableAssetCard(asset: widget.asset, total: widget.total, onDetails: widget.onDetails),
      ),
    );
  }

  Widget _buildFlip() {
    final angle = _flip.value * math.pi;
    final showFront = angle > math.pi / 2;

    return Transform.translate(
      offset: Offset(0, (1 - _appear.value) * 240),
      child: Opacity(
        opacity: _appear.value.clamp(0, 1),
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0014)
            ..rotateY(angle),
          child: AspectRatio(
            aspectRatio: assetCardAspectRatio,
            child: showFront
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: AssetCardFront(asset: widget.asset, total: widget.total),
                  )
                : const _CardBackFace(),
          ),
        ),
      ),
    );
  }
}

class _CardBackFace extends StatelessWidget {
  const _CardBackFace();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: CardReveal._borderRadius,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.ink],
        ),
        border: Border.all(color: Colors.white, width: 4),
      ),
      child: Center(child: Text('V', style: AppTheme.display(96, color: Colors.white))),
    );
  }
}
