import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/network/api_error_message.dart';
import 'package:mobile/features/cards/data/models/asset_card_model.dart';
import 'package:mobile/features/cards/presentation/card_query.dart';
import 'package:mobile/features/cards/presentation/cards_provider.dart';
import 'package:mobile/features/cards/presentation/widgets/asset_card.dart';
import 'package:mobile/features/cards/presentation/widgets/search_sort_bar.dart';

class CardsScreen extends ConsumerWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(cardsProvider, (previous, next) {
      if (next.hasError && next.hasValue)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(apiErrorMessage(next.error!))));
    });

    final query = ref.watch(cardQueryProvider);
    final queryNotifier = ref.read(cardQueryProvider.notifier);
    final totalCards = ref.watch(cardsProvider).value?.length ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('All cards')),
      body: Column(
        children: [
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
              error: (error, stackTrace) => _ErrorView(
                message: apiErrorMessage(error),
                onRetry: () => ref.invalidate(cardsProvider),
              ),
              data: (cards) => totalCards == 0
                  ? const Center(child: Text('No cards available.'))
                  : RefreshIndicator(
                      onRefresh: () => ref.refresh(cardsProvider.future),
                      child: _CardsGrid(cards: cards, totalCards: totalCards, search: query.search),
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
  final String search;

  const _CardsGrid({required this.cards, required this.totalCards, required this.search});

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty)
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(32),
            child: Text('No card matches "$search".', textAlign: .center),
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
      itemBuilder: (context, index) => AssetCard(
        key: ValueKey(cards[index].id),
        card: cards[index],
        totalCards: totalCards,
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: .min,
          spacing: 16,
          children: [
            Text('Unable to load cards.\n$message', textAlign: .center),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
