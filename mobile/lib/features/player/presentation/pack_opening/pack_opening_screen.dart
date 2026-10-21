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
import 'package:mobile/features/player/presentation/pack_opening/widgets/card_reveal.dart';
import 'package:mobile/features/player/presentation/pack_opening/widgets/opening_pack.dart';
import 'package:mobile/features/player/presentation/pack_opening/widgets/opening_summary.dart';
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

  bool get _isLastPack => _index == widget.packs.length - 1;

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
        _phase = OpeningPhase.burst;
      });
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
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.indigo, AppColors.ink],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _TopBar(
                  label: _phase == OpeningPhase.summary ? null : 'Pack ${_index + 1} / ${widget.packs.length}',
                  onClose: _phase.isAnimating ? null : () => context.pop(),
                ),
                Expanded(child: _buildStage(totalCards)),
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

  Widget _buildStage(int totalCards) => switch (_phase) {
    OpeningPhase.ready || OpeningPhase.shaking || OpeningPhase.burst => GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _open,
      child: Center(
        child: OpeningPack(
          key: ValueKey(_index),
          type: _pack.type,
          phase: _phase,
          onBurstComplete: () => setState(() => _phase = OpeningPhase.reveal),
        ),
      ),
    ),
    OpeningPhase.reveal || OpeningPhase.revealed => Column(
      mainAxisAlignment: .center,
      spacing: 24,
      children: [
        CardReveal(
          key: ValueKey(_index),
          card: _results.last.card,
          totalCards: totalCards,
          onRevealed: () => setState(() => _phase = OpeningPhase.revealed),
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
      OpeningPhase.ready => Center(
        child: Text(
          'Tap the pack to open it',
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
