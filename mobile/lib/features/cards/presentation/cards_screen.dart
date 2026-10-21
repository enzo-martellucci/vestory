import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/network/api_error_message.dart';
import 'package:mobile/features/cards/data/models/asset_card_model.dart';
import 'package:mobile/features/cards/presentation/cards_provider.dart';
import 'package:mobile/features/cards/presentation/widgets/asset_card.dart';

class CardsScreen extends ConsumerWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(cardsProvider, (previous, next) {
      if (next.hasError && next.hasValue)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(apiErrorMessage(next.error!))));
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Collection')),
      body: ref.watch(cardsProvider).when(
        skipError: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _ErrorView(
          message: apiErrorMessage(error),
          onRetry: () => ref.invalidate(cardsProvider),
        ),
        data: (cards) => cards.isEmpty
            ? const Center(child: Text('No cards available.'))
            : RefreshIndicator(
                onRefresh: () => ref.refresh(cardsProvider.future),
                child: _CardsGrid(cards: cards),
              ),
      ),
    );
  }
}

class _CardsGrid extends StatelessWidget {
  final List<AssetCardModel> cards;

  const _CardsGrid({required this.cards});

  @override
  Widget build(BuildContext context) {
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
        totalCards: cards.length,
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
