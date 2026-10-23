import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/cards/data/models/asset.dart';
import 'package:mobile/features/cards/presentation/widgets/asset_card.dart';
import 'package:mobile/features/cards/presentation/widgets/recto/asset_card_front.dart';
import 'package:mobile/features/player/presentation/pack_opening/rarity_effects.dart';

class CardReveal extends StatefulWidget {
  static const width = 240.0;

  final Asset card;
  final int totalCards;
  final VoidCallback onRevealed;

  const CardReveal({super.key, required this.card, required this.totalCards, required this.onRevealed});

  @override
  State<CardReveal> createState() => _CardRevealState();
}

class _CardRevealState extends State<CardReveal> with TickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: widget.card.rarity.revealDuration);
  late final _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
    ..repeat(reverse: true);
  late final _appear = CurvedAnimation(parent: _controller, curve: const Interval(0, 0.3, curve: Curves.easeOutBack));
  late final _flip = CurvedAnimation(parent: _controller, curve: const Interval(0.4, 1, curve: Curves.easeInOutCubic));
  bool _revealed = false;

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
        final rarity = widget.card.rarity;
        final glow = rarity.glowStrength * (0.6 + 0.4 * _pulse.value) * (_flip.value > 0.5 ? 0.6 : 1);

        return Container(
          width: CardReveal.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              if (glow > 0)
                BoxShadow(
                  color: rarity.color.withValues(alpha: glow * _appear.value.clamp(0, 1)),
                  blurRadius: 24 + 32 * glow,
                  spreadRadius: 2 + 10 * glow,
                ),
            ],
          ),
          child: _revealed ? child : _buildFlip(),
        );
      },
      child: AssetCard(card: widget.card, totalCards: widget.totalCards),
    );
  }

  Widget _buildFlip() {
    final angle = _flip.value * math.pi;
    final showFront = angle > math.pi / 2;

    return Transform.scale(
      scale: 0.6 + 0.4 * _appear.value,
      child: Opacity(
        opacity: _appear.value.clamp(0, 1),
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0014)
            ..rotateY(angle),
          child: AspectRatio(
            aspectRatio: AssetCard.aspectRatio,
            child: showFront
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: AssetCardFront(card: widget.card, totalCards: widget.totalCards),
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
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.indigo, AppColors.ink],
        ),
        border: Border.all(color: AppColors.vanilla, width: 4),
      ),
      child: const Center(
        child: Text(
          'V',
          style: TextStyle(color: AppColors.vanilla, fontSize: 96, fontWeight: .w900),
        ),
      ),
    );
  }
}
