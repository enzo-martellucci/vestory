import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';
import '../../../core/widgets/flip_card.dart';
import '../../market/controllers/asset_market_controller.dart';
import '../models/asset_card_model.dart';
import 'recto/asset_card_front.dart';
import 'verso/asset_card_back.dart';

class AssetCard extends StatefulWidget {
  static const double aspectRatio = 0.72;

  final AssetCardModel card;
  final int totalCards;

  const AssetCard({
    super.key,
    required this.card,
    required this.totalCards,
  });

  @override
  State<AssetCard> createState() => _AssetCardState();
}

class _AssetCardState extends State<AssetCard> {
  AssetMarketController? _market;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _market ??= AssetMarketController(
      AppScope.of(context).marketRepository,
      widget.card.financialAssetId,
    );
  }

  @override
  void dispose() {
    _market?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final market = _market!;

    return AspectRatio(
      aspectRatio: AssetCard.aspectRatio,
      child: FlipCard(
        // Données chargées paresseusement, au premier retournement.
        onFlip: (showBack) {
          if (showBack) market.ensureLoaded();
        },
        front: AssetCardFront(card: widget.card, totalCards: widget.totalCards),
        back: ListenableBuilder(
          listenable: market,
          builder: (context, _) => AssetCardBack(
            card: widget.card,
            quote: market.quote,
            history: market.history,
          ),
        ),
      ),
    );
  }
}
