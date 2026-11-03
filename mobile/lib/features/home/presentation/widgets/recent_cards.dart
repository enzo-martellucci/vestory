import 'package:material_ui/material_ui.dart';
import 'package:mobile/features/cards/presentation/widgets/asset_card.dart';
import 'package:mobile/features/cards/presentation/widgets/card_front.dart';
import 'package:mobile/features/player/data/models/player_profile.dart';

class RecentCards extends StatelessWidget {
  static const _cardWidth = 150.0;

  final List<OwnedAsset> cards;
  final int totalCards;

  const RecentCards({super.key, required this.cards, required this.totalCards});

  void _show(BuildContext context, OwnedAsset owned) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (context) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: AssetCard(card: owned.asset, totalCards: totalCards),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 12,
      children: [
        const Text('Your latest cards', style: TextStyle(fontSize: 20, fontWeight: .w900)),
        SizedBox(
          height: _cardWidth / AssetCard.aspectRatio,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: cards.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => _show(context, cards[index]),
              child: SizedBox(
                width: _cardWidth,
                child: AssetCardFront(card: cards[index].asset, totalCards: totalCards),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
