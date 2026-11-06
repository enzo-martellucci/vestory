import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/format/formatters.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/time/clock.dart';
import 'package:mobile/features/assets/domain/rarity.dart';
import 'package:mobile/features/assets/presentation/asset_providers.dart';
import 'package:mobile/features/assets/presentation/asset_style.dart';
import 'package:mobile/features/market/presentation/asset_detail_sheet.dart';
import 'package:mobile/features/packs/data/pack_repository.dart';
import 'package:mobile/features/packs/domain/pack_opening.dart';
import 'package:mobile/features/packs/domain/pack_type.dart';
import 'package:mobile/features/packs/presentation/opening/card_reveal.dart';
import 'package:mobile/features/packs/presentation/opening/opening_effects.dart';
import 'package:mobile/features/packs/presentation/opening/opening_pack.dart';
import 'package:mobile/features/packs/presentation/opening/rarity_effects.dart';
import 'package:mobile/features/packs/presentation/opening/walkout_sequence.dart';
import 'package:mobile/features/packs/presentation/pack_art.dart';
import 'package:mobile/features/player/presentation/player_providers.dart';

class PackOpeningScreen extends ConsumerStatefulWidget {
  final PackType type;
  final bool isDaily;

  const PackOpeningScreen({super.key, required this.type, this.isDaily = false});

  @override
  ConsumerState<PackOpeningScreen> createState() => _PackOpeningScreenState();
}

class _PackOpeningScreenState extends ConsumerState<PackOpeningScreen> {
  var _phase = OpeningPhase.ready;
  PackOpening? _opening;

  bool get _isLegendary => _opening?.asset.rarity == Rarity.legendary;

  bool _hasReached(OpeningPhase phase) => _phase.index >= phase.index;

  List<Color> get _backgroundColors {
    final rarity = _opening?.asset.rarity;
    if (rarity != null && (_isLegendary || _hasReached(OpeningPhase.walkout)))
      return rarity.backgroundColors;
    return [Color.lerp(widget.type.glow, AppColors.ink, 0.45)!, AppColors.ink];
  }

  Future<void> _open() async {
    setState(() => _phase = OpeningPhase.shaking);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final repository = ref.read(packRepositoryProvider);
      final now = ref.read(clockProvider)();
      final results = await Future.wait([
        widget.isDaily ? repository.openDailyPack(now) : repository.buyAndOpen(widget.type, now),
        Future<void>.delayed(OpeningPack.shakeDuration),
      ]);
      final opening = results.first as PackOpening;
      if (!mounted)
        return;

      setState(() {
        _opening = opening;
        _phase = OpeningPhase.charging;
      });
      await Future<void>.delayed(opening.asset.rarity.chargeDuration);
      if (!mounted)
        return;

      opening.asset.rarity.haptic();
      setState(() => _phase = OpeningPhase.burst);
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text('$error')));
      if (mounted)
        setState(() => _phase = OpeningPhase.ready);
    }
  }

  void _onRevealed() {
    setState(() => _phase = OpeningPhase.revealed);
    if (_isLegendary)
      _opening!.asset.rarity.haptic();
  }

  @override
  Widget build(BuildContext context) {
    final gems = ref.watch(playerProvider).value?.gems ?? 0;
    final total = ref.watch(assetsProvider).value?.length ?? 0;

    return PopScope(
      canPop: !_phase.isAnimating,
      child: Scaffold(
        backgroundColor: AppColors.ink,
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: _backgroundColors),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: _phase.isAnimating ? null : () => context.pop(),
                    icon: const Icon(Icons.close_rounded),
                    color: Colors.white,
                    disabledColor: Colors.white24,
                  ),
                ),
                Expanded(child: _buildEffects(_buildStage(total))),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: SizedBox(height: 52, child: _buildActions(gems)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEffects(Widget stage) {
    final opening = _opening;

    return Stack(
      alignment: Alignment.center,
      children: [
        const Positioned.fill(child: IgnorePointer(child: AmbientParticles())),
        Positioned(
          top: -160,
          child: IgnorePointer(
            child: AnimatedOpacity(
              opacity: _hasReached(OpeningPhase.walkout) ? 0 : 1,
              duration: const Duration(milliseconds: 500),
              child: Container(
                width: 520,
                height: 620,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1,
                    colors: [Colors.white.withValues(alpha: 0.22), Colors.white.withValues(alpha: 0.06), Colors.transparent],
                    stops: const [0, 0.5, 1],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_isLegendary && _hasReached(OpeningPhase.walkout)) const IgnorePointer(child: LegendaryRays()),
        stage,
        if (opening != null && _hasReached(OpeningPhase.burst))
          Positioned.fill(
            child: IgnorePointer(
              child: ParticleBurst(color: opening.asset.rarity.color, count: opening.asset.rarity.particleCount),
            ),
          ),
        if (_isLegendary && _phase == OpeningPhase.revealed) const Positioned.fill(child: IgnorePointer(child: SparkleRain())),
      ],
    );
  }

  Widget _buildStage(int total) => switch (_phase) {
    OpeningPhase.ready || OpeningPhase.shaking || OpeningPhase.charging || OpeningPhase.burst => OpeningPack(
      type: widget.type,
      rarity: _opening?.asset.rarity,
      phase: _phase,
      onHoldComplete: _open,
      onBurstComplete: () => setState(() => _phase = OpeningPhase.walkout),
    ),
    OpeningPhase.walkout => WalkoutSequence(
      asset: _opening!.asset,
      onComplete: () => setState(() => _phase = OpeningPhase.reveal),
    ),
    OpeningPhase.reveal || OpeningPhase.revealed => _buildReveal(_opening!, total),
  };

  Widget _buildReveal(PackOpening opening, int total) {
    final isRevealed = _phase == OpeningPhase.revealed;

    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 20,
          children: [
            if (_isLegendary) SizedBox(height: 48, child: isRevealed ? const _LegendaryBanner() : null),
            CardReveal(
              asset: opening.asset,
              total: total,
              onRevealed: _onRevealed,
              onDetails: () => showAssetDetailSheet(context, opening.asset),
            ),
            SizedBox(height: 40, child: isRevealed ? _ResultBadge(opening: opening) : null),
          ],
        ),
      ),
    );
  }

  Widget? _buildActions(int gems) {
    final hint = switch (_phase) {
      OpeningPhase.ready => widget.isDaily ? 'Hold the pack to open it' : 'Hold the pack to open it · ${formatGems(widget.type.price)} gems',
      OpeningPhase.walkout => 'Tap to skip',
      _ => null,
    };
    if (hint != null)
      return Center(
        child: Text(hint, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontWeight: FontWeight.w600)),
      );
    if (_phase != OpeningPhase.revealed)
      return null;

    final canBuyAnother = !widget.isDaily && gems >= widget.type.price;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white24)),
            onPressed: () => context.go('/collection'),
            child: const Text('Collection'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton(
            onPressed: canBuyAnother ? () => context.pushReplacement('/open/${widget.type.name}') : () => context.pop(),
            child: Text(canBuyAnother ? 'Buy another' : 'Done'),
          ),
        ),
      ],
    );
  }
}

class _LegendaryBanner extends StatelessWidget {
  const _LegendaryBanner();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.elasticOut,
      builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
      child: Text(
        'LEGENDARY!',
        style: TextStyle(
          color: Rarity.legendary.color,
          fontSize: 36,
          fontWeight: FontWeight.w900,
          letterSpacing: 3,
          shadows: [Shadow(color: Rarity.legendary.gradient.first, blurRadius: 18)],
        ),
      ),
    );
  }
}

class _ResultBadge extends StatelessWidget {
  final PackOpening opening;

  const _ResultBadge({required this.opening});

  @override
  Widget build(BuildContext context) {
    final color = opening.isNew ? AppColors.positive : AppColors.gem;
    const textStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.w800);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 16)],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            Icon(opening.isNew ? Icons.fiber_new_rounded : Icons.diamond_rounded, color: Colors.white, size: 20),
            if (opening.isNew)
              const Text('New card!', style: textStyle)
            else
              TweenAnimationBuilder<int>(
                tween: IntTween(begin: 0, end: opening.gemsEarned),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOutCubic,
                builder: (context, gems, _) => Text('Duplicate · +$gems gems', style: textStyle),
              ),
          ],
        ),
      ),
    );
  }
}
