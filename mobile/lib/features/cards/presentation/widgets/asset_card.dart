import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/widgets/flip_card.dart';
import 'package:mobile/features/cards/data/models/asset_card_model.dart';
import 'package:mobile/features/cards/presentation/widgets/recto/asset_card_front.dart';
import 'package:mobile/features/cards/presentation/widgets/verso/asset_card_back.dart';
import 'package:mobile/features/market/presentation/market_providers.dart';

class AssetCard extends ConsumerStatefulWidget {
  static const double aspectRatio = 0.72;

  final AssetCardModel card;
  final int totalCards;

  const AssetCard({super.key, required this.card, required this.totalCards});

  @override
  ConsumerState<AssetCard> createState() => _AssetCardState();
}

class _AssetCardState extends ConsumerState<AssetCard> {
  bool _flipped = false;

  void _onFlip(bool showBack) {
    if (!showBack)
      return;
    if (!_flipped) {
      setState(() => _flipped = true);
      return;
    }

    final assetId = widget.card.assetId;
    if (ref.read(quoteProvider(assetId)).hasError)
      ref.invalidate(quoteProvider(assetId));
    if (ref.read(historyProvider(assetId)).hasError)
      ref.invalidate(historyProvider(assetId));
  }

  @override
  Widget build(BuildContext context) {
    final assetId = widget.card.assetId;

    return AspectRatio(
      aspectRatio: AssetCard.aspectRatio,
      child: FlipCard(
        onFlip: _onFlip,
        front: AssetCardFront(card: widget.card, totalCards: widget.totalCards),
        back: AssetCardBack(
          card: widget.card,
          quote: _flipped ? ref.watch(quoteProvider(assetId)) : null,
          history: _flipped ? ref.watch(historyProvider(assetId)) : null,
        ),
      ),
    );
  }
}
