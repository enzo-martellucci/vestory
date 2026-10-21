import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/network/api_error_message.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/error_view.dart';
import 'package:mobile/features/player/data/models/pack_type.dart';
import 'package:mobile/features/player/presentation/player_providers.dart';
import 'package:mobile/features/player/presentation/widgets/gems_badge.dart';
import 'package:mobile/features/shop/presentation/widgets/pack_offer_card.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(playerProfileProvider);
    final gems = profile.value?.gems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop', style: TextStyle(fontWeight: .w800)),
        actions: [
          if (gems != null)
            Padding(padding: const EdgeInsets.only(right: 16), child: GemsBadge(gems: gems)),
        ],
      ),
      body: profile.when(
        skipError: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ErrorView(
          message: apiErrorMessage(error),
          onRetry: () => ref.invalidate(playerProfileProvider),
        ),
        data: (profile) => RefreshIndicator(
          onRefresh: () => ref.refresh(playerProfileProvider.future),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              for (final type in PackType.values) ...[
                PackOfferCard(type: type, gems: profile.gems),
                const SizedBox(height: 16),
              ],
              const Text(
                'Duplicates give gems: Common 2 · Rare 10 · Epic 50 · Legendary 100',
                textAlign: .center,
                style: TextStyle(color: AppColors.muted, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
