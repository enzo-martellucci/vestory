import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/network/api_error_message.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/app_panel.dart';
import 'package:mobile/features/player/data/models/pack_type.dart';
import 'package:mobile/features/player/data/player_repository.dart';
import 'package:mobile/features/player/presentation/player_providers.dart';
import 'package:mobile/features/player/presentation/widgets/pack_visual.dart';
import 'package:mobile/features/shop/presentation/widgets/pack_odds_bar.dart';

class PackOfferCard extends ConsumerStatefulWidget {
  final PackType type;
  final int gems;

  const PackOfferCard({super.key, required this.type, required this.gems});

  @override
  ConsumerState<PackOfferCard> createState() => _PackOfferCardState();
}

class _PackOfferCardState extends ConsumerState<PackOfferCard> {
  bool _buying = false;

  Future<void> _buy() async {
    final type = widget.type;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Buy a ${type.label} pack?'),
        content: Text('This will cost ${type.price} gems.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Buy')),
        ],
      ),
    );
    if (confirmed != true || !mounted)
      return;

    setState(() => _buying = true);
    try {
      final pack = await ref.read(playerRepositoryProvider).buyPack(type);
      ref.invalidate(playerProfileProvider);
      if (mounted)
        context.push('/packs/open', extra: [pack]);
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(apiErrorMessage(error))));
    } finally {
      if (mounted)
        setState(() => _buying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.type;
    final missingGems = type.price - widget.gems;

    return AppPanel(
      child: Column(
        spacing: 16,
        children: [
          Row(
            spacing: 16,
            children: [
              PackVisual(type: type, width: 72),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: 8,
                  children: [
                    Text(type.label, style: const TextStyle(fontSize: 18, fontWeight: .w800)),
                    PackOddsBar(type: type),
                  ],
                ),
              ),
            ],
          ),
          FilledButton(
            onPressed: missingGems <= 0 && !_buying ? _buy : null,
            child: _buying
                ? const SizedBox.square(dimension: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                : Row(
                    mainAxisSize: .min,
                    spacing: 6,
                    children: [const Icon(Icons.diamond, size: 18), Text('${type.price}')],
                  ),
          ),
          if (missingGems > 0)
            Text('Need $missingGems more gems', style: const TextStyle(color: AppColors.muted, fontSize: 13)),
        ],
      ),
    );
  }
}
