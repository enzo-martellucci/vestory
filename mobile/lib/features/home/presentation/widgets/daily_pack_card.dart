import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/network/api_error_message.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/app_panel.dart';
import 'package:mobile/core/widgets/floating.dart';
import 'package:mobile/core/widgets/shine_sweep.dart';
import 'package:mobile/features/player/data/models/pack.dart';
import 'package:mobile/features/player/data/models/player_profile.dart';
import 'package:mobile/features/player/data/player_repository.dart';
import 'package:mobile/features/player/presentation/player_providers.dart';
import 'package:mobile/features/player/presentation/widgets/pack_visual.dart';

class DailyPackCard extends ConsumerStatefulWidget {
  final PlayerProfile profile;

  const DailyPackCard({super.key, required this.profile});

  @override
  ConsumerState<DailyPackCard> createState() => _DailyPackCardState();
}

class _DailyPackCardState extends ConsumerState<DailyPackCard> {
  static const _packWidth = 84.0;

  Timer? _timer;
  bool _claiming = false;

  @override
  void initState() {
    super.initState();
    _syncTimer();
  }

  @override
  void didUpdateWidget(DailyPackCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _syncTimer() {
    _timer?.cancel();
    if (widget.profile.nextDailyPackAt != null)
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (_remaining() <= Duration.zero) {
      _timer?.cancel();
      ref.invalidate(playerProfileProvider);
    }
    setState(() {});
  }

  Duration _remaining() => widget.profile.nextDailyPackAt?.difference(DateTime.now()) ?? Duration.zero;

  Future<void> _claim() async {
    setState(() => _claiming = true);
    try {
      await ref.read(playerRepositoryProvider).claimDailyPack();
      ref.invalidate(playerProfileProvider);
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(apiErrorMessage(error))));
    } finally {
      if (mounted)
        setState(() => _claiming = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final available = widget.profile.dailyPackAvailable;
    final remaining = _remaining();

    return AppPanel(
      child: Column(
        spacing: 18,
        children: [
          Row(
            spacing: 18,
            children: [
              available
                  ? Floating(
                      child: ShineSweep(
                        borderRadius: BorderRadius.circular(_packWidth * 0.12),
                        child: const PackVisual(type: PackType.standard, width: _packWidth),
                      ),
                    )
                  : const Opacity(opacity: 0.35, child: PackVisual(type: PackType.standard, width: _packWidth)),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: 8,
                  children: [
                    Row(
                      spacing: 8,
                      children: [
                        const Text('Daily pack', style: TextStyle(fontSize: 20, fontWeight: .w900)),
                        if (available)
                          const _Chip(label: 'FREE'),
                      ],
                    ),
                    Text(
                      available ? 'Your free pack is ready to claim!' : 'Next free pack in',
                      style: const TextStyle(color: AppColors.muted),
                    ),
                    if (!available)
                      Row(
                        spacing: 6,
                        children: [
                          _TimeBlock(value: remaining.inHours, unit: 'h'),
                          _TimeBlock(value: remaining.inMinutes % 60, unit: 'min'),
                          _TimeBlock(value: remaining.inSeconds % 60, unit: 's'),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (available)
            FilledButton.icon(
              onPressed: _claiming ? null : _claim,
              icon: _claiming
                  ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2.5))
                  : const Icon(Icons.redeem),
              label: const Text('Claim'),
            ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;

  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: AppColors.positive, borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: .w900, letterSpacing: 1)),
    );
  }
}

class _TimeBlock extends StatelessWidget {
  final int value;
  final String unit;

  const _TimeBlock({required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.indigo.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: value.toString().padLeft(2, '0'),
              style: const TextStyle(color: AppColors.indigo, fontSize: 18, fontWeight: .w900),
            ),
            TextSpan(text: ' $unit', style: const TextStyle(color: AppColors.muted, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
