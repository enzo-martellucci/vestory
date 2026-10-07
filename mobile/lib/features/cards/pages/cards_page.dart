import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';
import '../../../core/state/async_value.dart';
import '../controllers/cards_controller.dart';
import '../models/asset_card_model.dart';
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
    // Le controller est créé une seule fois, à partir de l'AppScope.
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller!;

    return Scaffold(
      appBar: AppBar(title: const Text('Vestory')),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) => switch (controller.state) {
          AsyncLoading() => const Center(child: CircularProgressIndicator()),
          AsyncError(:final message) => _ErrorView(
              message: message,
              onRetry: controller.load,
            ),
          AsyncData(:final value) when value.isEmpty =>
            const Center(child: Text('No cards available.')),
          AsyncData(:final value) => RefreshIndicator(
              onRefresh: _refresh,
              child: _CardsGrid(cards: value),
            ),
        },
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
        // La clé garantit que l'état (face retournée, données) suit
        // la bonne carte si la liste est réordonnée après un refresh.
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Unable to load cards.\n$message',
              textAlign: TextAlign.center,
            ),
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
