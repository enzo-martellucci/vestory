import 'package:flutter/material.dart';

import '../models/asset_card_model.dart';
import '../repositories/card_repository.dart';
import '../widgets/asset_card.dart';
import '../../market/repositories/market_repository.dart';

class CardsPage extends StatefulWidget {
  final CardRepository cardRepository;
  final MarketRepository marketRepository;

  const CardsPage({
    super.key,
    required this.cardRepository,
    required this.marketRepository,
  });

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  late Future<List<AssetCardModel>> _cardsFuture;

  @override
  void initState() {
    super.initState();

    _cardsFuture = widget.cardRepository.getCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vestory'),
      ),

      body: FutureBuilder<List<AssetCardModel>>(
        future: _cardsFuture,

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Unable to load cards.'
                      '${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final cards = snapshot.data ?? [];

          if (cards.isEmpty) {
            return const Center(
              child: Text(
                'No cards available.',
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),

            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),

            itemCount: cards.length,

            itemBuilder: (context, index) {
              final card = cards[index];

              return AssetCard(
                card: card,
                totalCards: cards.length,
                marketRepository:
                widget.marketRepository,
              );
            },
          );
        },
      ),
    );
  }
}