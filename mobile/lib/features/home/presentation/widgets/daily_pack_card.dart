import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/network/api_error_message.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/home/presentation/widgets/home_panel.dart';
import 'package:mobile/features/player/data/models/pack_type.dart';
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

    return HomePanel(
      child: Column(
        spacing: 16,
        children: [
          Row(
            spacing: 16,
            children: [
              Opacity(opacity: available ? 1 : 0.4, child: const PackVisual(type: PackType.standard, width: 64)),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: 4,
                  children: [
                    const Text('Daily pack', style: TextStyle(fontSize: 18, fontWeight: .w800)),
                    Text(
                      available ? 'Your free pack is ready!' : 'Next pack in ${_format(_remaining())}',
                      style: const TextStyle(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (available)
            FilledButton(
              onPressed: _claiming ? null : _claim,
              child: _claiming
                  ? const SizedBox.square(dimension: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                  : const Text('Claim'),
            ),
        ],
      ),
    );
  }

  static String _format(Duration duration) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes % 60)}:${twoDigits(duration.inSeconds % 60)}';
  }
}
