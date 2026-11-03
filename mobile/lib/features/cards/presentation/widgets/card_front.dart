import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/cards/data/models/asset.dart';
import 'package:mobile/features/cards/data/models/rarity.dart';
import 'package:mobile/features/cards/presentation/widgets/card_frame.dart';

class AssetCardFront extends StatelessWidget {
  final Asset card;
  final int totalCards;

  const AssetCardFront({
    super.key,
    required this.card,
    required this.totalCards,
  });

  @override
  Widget build(BuildContext context) {
    return CardFrame(
      rarity: card.rarity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 6,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _Background(
                  imageUrl: card.logoUrl,
                  rarityColor: card.rarity.color,
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: _RarityBadge(rarity: card.rarity),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 9,
            child: _InfoSection(card: card, totalCards: totalCards),
          ),
        ],
      ),
    );
  }
}

class _Background extends StatelessWidget {
  final String? imageUrl;
  final Color rarityColor;

  const _Background({
    required this.imageUrl,
    required this.rarityColor,
  });

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    if (url == null || url.isEmpty) {
      return _fallback();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _fallback(),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.05),
                Colors.transparent,
                Colors.black.withValues(alpha: 0.06),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _fallback() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.cardFallbackSurface,
            rarityColor.withValues(alpha: 0.12),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.show_chart_rounded,
          size: 44,
          color: rarityColor.withValues(alpha: 0.55),
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final Asset card;
  final int totalCards;

  const _InfoSection({
    required this.card,
    required this.totalCards,
  });

  String get _description {
    final value = card.description?.trim();
    return (value == null || value.isEmpty)
        ? 'No description available.'
        : value;
  }

  String? get _origin {
    final parts = [card.country, card.sector]
        .whereType<String>()
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty);
    return parts.isEmpty ? null : parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final origin = _origin;

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 14, 15, 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            card.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 11,
              height: 1.15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: card.symbol,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (origin != null) TextSpan(text: ' · $origin'),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 7,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Text(
                _description,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 7,
                  height: 1.4,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.only(top: 8, bottom: 2),
            color: AppColors.divider,
          ),
          _Footer(
            assetType: card.type,
            collectionNumber: card.id,
            totalCards: totalCards,
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final String assetType;
  final int collectionNumber;
  final int totalCards;

  const _Footer({
    required this.assetType,
    required this.collectionNumber,
    required this.totalCards,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          assetType,
          style: const TextStyle(
            color: AppColors.textBody,
            fontSize: 6,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          '$collectionNumber/$totalCards',
          style: const TextStyle(
            color: AppColors.textBody,
            fontSize: 6,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _RarityBadge extends StatelessWidget {
  final Rarity rarity;

  const _RarityBadge({required this.rarity});

  @override
  Widget build(BuildContext context) {
    final color = rarity.color;

    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: color, width: 1.3),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.30), blurRadius: 8),
        ],
      ),
      child: Text(
        rarity.letter,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
