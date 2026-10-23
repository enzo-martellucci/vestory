import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/network/api_error_message.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/cards/presentation/cards_provider.dart';
import 'package:mobile/features/player/data/models/pack_opening_result.dart';
import 'package:mobile/features/player/data/models/user_pack.dart';
import 'package:mobile/features/player/data/player_repository.dart';
import 'package:mobile/features/player/presentation/pack_opening/opening_phase.dart';
import 'package:mobile/features/player/presentation/pack_opening/rarity_effects.dart';
import 'package:mobile/features/player/presentation/pack_opening/widgets/card_reveal.dart';
import 'package:mobile/features/player/presentation/pack_opening/widgets/legendary_effects.dart';
import 'package:mobile/features/player/presentation/pack_opening/widgets/opening_pack.dart';
import 'package:mobile/features/player/presentation/pack_opening/widgets/opening_summary.dart';
import 'package:mobile/features/player/presentation/pack_opening/widgets/particle_burst.dart';
import 'package:mobile/features/player/presentation/pack_opening/widgets/walkout_sequence.dart';
import 'package:mobile/features/player/presentation/player_providers.dart';

class PackOpeningScreen extends ConsumerStatefulWidget {
  final List<UserPack> packs;

  const PackOpeningScreen({super.key, required this.packs});

  @override
  ConsumerState<PackOpeningScreen> createState() => _PackOpeningScreenState();
}

class _PackOpeningScreenState extends ConsumerState<PackOpeningScreen> {
  final _results = <PackOpeningResult>[];
  OpeningPhase _phase = OpeningPhase.ready;
  int _index = 0;

  UserPack get _pack => widget.packs[_index];

  PackOpeningResult? get _result => _results.length > _index ? _results[_index] : null;

  bool get _isLastPack => _index == widget.packs.length - 1;

  bool get _isLegendaryMoment =>
      (_result?.card.rarity.isLegendary ?? false) && _phase != OpeningPhase.ready && _phase != OpeningPhase.summary;

  List<Color> get _backgroundColors {
    final rarity = _result?.card.rarity;
    final rarityRevealed = _phase.index >= OpeningPhase.walkout.index && _phase != OpeningPhase.summary;
    if (rarity != null && (_isLegendaryMoment || rarityRevealed))
      return rarity.backgroundColors;
    return const [AppColors.indigo, AppColors.ink];
  }

  Future<void> _open() async {
    if (_phase != OpeningPhase.ready)
      return;
    setState(() => _phase = OpeningPhase.shaking);

    final shake = Future<void>.delayed(OpeningPack.shakeDuration);
    try {
      final result = await ref.read(playerRepositoryProvider).openPack(_pack.id);
      ref.invalidate(playerProfileProvider);
      ref.invalidate(collectionProvider);
      await shake;
      if (!mounted)
        return;
      setState(() {
        _results.add(result);
        _phase = OpeningPhase.charging;
      });

      final rarity = result.card.rarity;
      await Future<void>.delayed(rarity.chargeDuration);
      if (!mounted)
        return;
      setState(() => _phase = OpeningPhase.burst);
      rarity.haptic();
    } catch (error) {
      if (!mounted)
        return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(apiErrorMessage(error))));
      setState(() => _phase = OpeningPhase.ready);
    }
  }

  void _next() => setState(() {
    if (_isLastPack)
      _phase = OpeningPhase.summary;
    else {
      _index++;
      _phase = OpeningPhase.ready;
    }
  });

  @override
  Widget build(BuildContext context) {
    final totalCards = ref.watch(cardsProvider).value?.length ?? 0;

    return PopScope(
      canPop: !_phase.isAnimating,
      child: Scaffold(
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: _backgroundColors,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _TopBar(
                  label: _phase == OpeningPhase.summary ? null : 'Pack ${_index + 1} / ${widget.packs.length}',
                  onClose: _phase.isAnimating ? null : () => context.pop(),
                ),
                Expanded(child: _buildEffects(_buildStage(totalCards))),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 24),
                  child: SizedBox(height: 54, child: _buildAction()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEffects(Widget stage) {
    final result = _result;
    final showBurst = result != null && _phase.index >= OpeningPhase.burst.index && _phase != OpeningPhase.summary;
    final showRays = _isLegendaryMoment && _phase.index >= OpeningPhase.walkout.index;

    return Stack(
      alignment: .center,
      children: [
        if (showRays)
          const IgnorePointer(child: LegendaryRays()),
        stage,
        if (showBurst)
          Positioned.fill(
            child: IgnorePointer(
              child: ParticleBurst(
                key: ValueKey(_index),
                color: result.card.rarity.color,
                count: result.card.rarity.particleCount,
              ),
            ),
          ),
        if (_isLegendaryMoment && _phase == OpeningPhase.revealed)
          const Positioned.fill(child: IgnorePointer(child: SparkleRain())),
      ],
    );
  }

  void _onRevealed() {
    setState(() => _phase = OpeningPhase.revealed);
    if (_isLegendaryMoment)
      _result!.card.rarity.haptic();
  }

  Widget _buildStage(int totalCards) => switch (_phase) {
    OpeningPhase.ready || OpeningPhase.shaking || OpeningPhase.charging || OpeningPhase.burst => GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _open,
      child: Center(
        child: OpeningPack(
          key: ValueKey(_index),
          type: _pack.type,
          rarity: _result?.card.rarity,
          phase: _phase,
          onBurstComplete: () => setState(() => _phase = OpeningPhase.walkout),
        ),
      ),
    ),
    OpeningPhase.walkout => WalkoutSequence(
      key: ValueKey(_index),
      card: _results.last.card,
      onComplete: () => setState(() => _phase = OpeningPhase.reveal),
    ),
    OpeningPhase.reveal || OpeningPhase.revealed => Column(
      mainAxisAlignment: .center,
      spacing: 24,
      children: [
        if (_isLegendaryMoment)
          SizedBox(height: 48, child: _phase == OpeningPhase.revealed ? const _LegendaryBanner() : null),
        CardReveal(
          key: ValueKey(_index),
          card: _results.last.card,
          totalCards: totalCards,
          onRevealed: _onRevealed,
        ),
        Opacity(
          opacity: _phase == OpeningPhase.revealed ? 1 : 0,
          child: _ResultBadge(result: _results.last),
        ),
      ],
    ),
    OpeningPhase.summary => OpeningSummary(results: _results, totalCards: totalCards),
  };

  Widget? _buildAction() {
    final style = FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.indigo);

    return switch (_phase) {
      OpeningPhase.ready || OpeningPhase.walkout => Center(
        child: Text(
          _phase == OpeningPhase.ready ? 'Tap the pack to open it' : 'Tap to skip',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontWeight: .w600),
        ),
      ),
      OpeningPhase.revealed => FilledButton(
        style: style,
        onPressed: _next,
        child: Text(_isLastPack ? 'See results' : 'Next pack'),
      ),
      OpeningPhase.summary => FilledButton(style: style, onPressed: () => context.pop(), child: const Text('Done')),
      _ => null,
    };
  }
}

class _TopBar extends StatelessWidget {
  final String? label;
  final VoidCallback? onClose;

  const _TopBar({required this.label, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close),
            color: Colors.white,
            disabledColor: Colors.white24,
          ),
          Expanded(
            child: Text(
              label ?? '',
              textAlign: .center,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: .w700),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
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
      child: const Text(
        'LEGENDARY!',
        style: TextStyle(
          color: AppColors.legendary,
          fontSize: 36,
          fontWeight: .w900,
          letterSpacing: 3,
          shadows: [Shadow(color: AppColors.legendaryTint, blurRadius: 18)],
        ),
      ),
    );
  }
}

class _ResultBadge extends StatelessWidget {
  final PackOpeningResult result;

  const _ResultBadge({required this.result});

  @override
  Widget build(BuildContext context) {
    final color = result.newCard ? AppColors.positive : AppColors.rare;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: .min,
        spacing: 6,
        children: [
          Icon(result.newCard ? Icons.fiber_new : Icons.diamond, color: Colors.white, size: 20),
          Text(
            result.newCard ? 'New card!' : 'Duplicate · +${result.gemsEarned} gems',
            style: const TextStyle(color: Colors.white, fontWeight: .w800),
          ),
        ],
      ),
    );
  }
}
