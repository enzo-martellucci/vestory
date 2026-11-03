import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/network/api_error_message.dart';
import 'package:mobile/core/widgets/error_view.dart';
import 'package:mobile/core/widgets/fade_slide_in.dart';
import 'package:mobile/features/cards/presentation/cards_provider.dart';
import 'package:mobile/features/home/presentation/widgets/daily_pack_card.dart';
import 'package:mobile/features/home/presentation/widgets/home_header.dart';
import 'package:mobile/features/home/presentation/widgets/recent_cards.dart';
import 'package:mobile/features/home/presentation/widgets/shop_shortcut.dart';
import 'package:mobile/features/home/presentation/widgets/unopened_packs_card.dart';
import 'package:mobile/features/player/data/models/player_profile.dart';
import 'package:mobile/features/player/presentation/player_providers.dart';
import 'package:mobile/features/player/presentation/widgets/open_packs_sheet.dart';
import 'package:mobile/features/user/presentation/current_user_provider.dart';

class HomeScreen extends ConsumerWidget {
  static const _recentCardsCount = 5;

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(playerProfileProvider, (previous, next) {
      if (next.hasError && next.hasValue)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(apiErrorMessage(next.error!))));
    });

    final username = ref.watch(currentUserProvider).value?.username ?? '';
    final collection = ref.watch(collectionProvider).value ?? const <OwnedAsset>[];
    final totalCards = ref.watch(assetsProvider).value?.length ?? 0;
    final recentCards = [...collection]
      ..sort((a, b) => b.lastObtainedAt.compareTo(a.lastObtainedAt));

    Future<void> refresh() => Future.wait([ref.refresh(playerProfileProvider.future), ref.refresh(collectionProvider.future)]);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ref.watch(playerProfileProvider).when(
          skipError: true,
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => ErrorView(
            message: apiErrorMessage(error),
            onRetry: () => ref.invalidate(playerProfileProvider),
          ),
          data: (profile) => RefreshIndicator(
            onRefresh: refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                for (final (index, section) in [
                  HomeHeader(
                    username: username,
                    gems: profile.gems,
                    ownedCards: collection.length,
                    totalCards: totalCards,
                    unopenedPacks: profile.unopenedPacks.length,
                  ),
                  DailyPackCard(profile: profile),
                  if (profile.unopenedPacks.isNotEmpty)
                    UnopenedPacksCard(
                      packs: profile.unopenedPacks,
                      onOpen: () async {
                        if (await confirmOpenPacks(context, profile.unopenedPacks) && context.mounted)
                          context.push('/packs/open', extra: profile.unopenedPacks);
                      },
                    ),
                  if (recentCards.isNotEmpty)
                    RecentCards(cards: recentCards.take(_recentCardsCount).toList(), totalCards: totalCards),
                  const ShopShortcut(),
                ].indexed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: FadeSlideIn(index: index, child: section),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
