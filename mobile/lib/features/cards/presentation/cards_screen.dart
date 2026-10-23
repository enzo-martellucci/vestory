import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/network/api_error_message.dart';
import 'package:mobile/core/widgets/error_view.dart';
import 'package:mobile/features/cards/data/models/asset_card_model.dart';
import 'package:mobile/features/cards/presentation/card_query.dart';
import 'package:mobile/features/cards/presentation/cards_provider.dart';
import 'package:mobile/features/cards/presentation/widgets/asset_card.dart';
import 'package:mobile/features/cards/presentation/widgets/collection_progress.dart';
import 'package:mobile/features/cards/presentation/widgets/locked_card.dart';
import 'package:mobile/features/cards/presentation/widgets/search_sort_bar.dart';
import 'package:mobile/features/player/presentation/player_providers.dart';

class CardsScreen extends ConsumerWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(visibleCardsProvider, (previous, next) {
      if (next.hasError && next.hasValue)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(apiErrorMessage(next.error!))));
    });

    final view = ref.watch(cardsViewProvider);
    final query = ref.watch(cardQueryProvider);
    final queryNotifier = ref.read(cardQueryProvider.notifier);
    final totalCards = ref.watch(cardsProvider).value?.length ?? 0;
    final ownedIds = ref.watch(ownedCardIdsProvider).value ?? const <String>{};

    Future<void> refresh() => Future.wait([ref.refresh(cardsProvider.future), ref.refresh(collectionProvider.future)]);

    return Scaffold(
      appBar: AppBar(title: const Text('Collection', style: TextStyle(fontWeight: .w800))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Column(
              spacing: 12,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<CardsView>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(value: CardsView.owned, label: Text('My cards'), icon: Icon(Icons.collections_bookmark)),
                      ButtonSegment(value: CardsView.all, label: Text('All cards'), icon: Icon(Icons.grid_view)),
                    ],
                    selected: {view},
                    onSelectionChanged: (selection) => ref.read(cardsViewProvider.notifier).select(selection.first),
                  ),
                ),
                CollectionProgress(owned: ownedIds.length, total: totalCards),
              ],
            ),
          ),
          SearchSortBar<CardSort>(
            hintText: 'Search by name or symbol',
            onSearchChanged: queryNotifier.setSearch,
            sortOptions: CardSort.values,
            selectedSort: query.sort,
            sortLabel: (sort) => sort.label,
            onSortChanged: queryNotifier.setSort,
          ),
          Expanded(
            child: ref.watch(visibleCardsProvider).when(
              skipError: true,
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => ErrorView(
                message: 'Unable to load cards.\n${apiErrorMessage(error)}',
                onRetry: () {
                  ref.invalidate(cardsProvider);
                  ref.invalidate(collectionProvider);
                },
              ),
              data: (cards) => RefreshIndicator(
                onRefresh: refresh,
                child: _CardsGrid(
                  cards: cards,
                  totalCards: totalCards,
                  ownedIds: ownedIds,
                  emptyMessage: switch (view) {
                    _ when query.search.trim().isNotEmpty => 'No card matches "${query.search.trim()}".',
                    CardsView.owned => 'No cards yet.\nOpen packs to start your collection!',
                    CardsView.all => 'No cards available.',
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardsGrid extends StatelessWidget {
  final List<AssetCardModel> cards;
  final int totalCards;
  final Set<String> ownedIds;
  final String emptyMessage;

  const _CardsGrid({
    required this.cards,
    required this.totalCards,
    required this.ownedIds,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty)
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(32),
            child: Text(emptyMessage, textAlign: .center),
          ),
        ],
      );

    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: AssetCard.aspectRatio,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        final assetCard = AssetCard(key: ValueKey(card.id), card: card, totalCards: totalCards);
        return ownedIds.contains(card.id) ? assetCard : LockedCard(child: assetCard);
      },
    );
  }
}
