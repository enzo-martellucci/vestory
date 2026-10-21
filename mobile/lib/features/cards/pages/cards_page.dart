import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';
import '../../../core/state/async_value.dart';
import '../widgets/search_sort_bar.dart';
import '../controllers/cards_controller.dart';
import '../models/asset_card_model.dart';
import '../models/card_query.dart';
import '../widgets/asset_card.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  CardsController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller == null) {
      _controller = CardsController(AppScope.of(context).cardRepository);
      _controller!.load();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    final error = await _controller!.refresh();
    if (error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller!;

    return Scaffold(
      appBar: AppBar(title: const Text('All cards')),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) => Column(
          children: [
            SearchSortBar<CardSort>(
              hintText: 'Search by name or symbol',
              onSearchChanged: controller.setSearch,
              sortOptions: CardSort.values,
              selectedSort: controller.sort,
              sortLabel: (sort) => sort.label,
              onSortChanged: controller.setSort,
            ),
            Expanded(
              child: switch (controller.state) {
                AsyncLoading() => const Center(child: CircularProgressIndicator()),
                AsyncError(:final message) => _ErrorView(
                  message: message,
                  onRetry: controller.load,
                ),
                AsyncData(:final value) when value.isEmpty =>
                const Center(child: Text('No cards available.')),
                AsyncData(:final value) => RefreshIndicator(
                  onRefresh: _refresh,
                  child: _CardsGrid(
                    cards: controller.visibleCards,
                    totalCards: value.length,
                    search: controller.search,
                  ),
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CardsGrid extends StatelessWidget {
  final List<AssetCardModel> cards;
  final int totalCards;
  final String search;

  const _CardsGrid({
    required this.cards,
    required this.totalCards,
    required this.search,
  });

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(32),
            child: Text('No card matches "$search".', textAlign: TextAlign.center),
          ),
        ],
      );
    }

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
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Unable to load cards.\n$message', textAlign: TextAlign.center),
            const SizedBox(height: 16),
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