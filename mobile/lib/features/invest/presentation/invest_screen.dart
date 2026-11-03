import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/network/api_error_message.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/app_network_image.dart';
import 'package:mobile/core/widgets/app_screen.dart';
import 'package:mobile/core/widgets/error_view.dart';
import 'package:mobile/core/widgets/fade_slide_in.dart';
import 'package:mobile/features/cards/data/models/asset.dart';
import 'package:mobile/features/player/presentation/player_providers.dart';

class InvestScreen extends ConsumerStatefulWidget {
  const InvestScreen({super.key});

  @override
  ConsumerState<InvestScreen> createState() => _InvestScreenState();
}

class _InvestScreenState extends ConsumerState<InvestScreen> {
  String _search = '';

  List<Asset> _filter(List<Asset> cards) {
    final term = _search.trim().toLowerCase();
    final filtered = term.isEmpty
        ? cards
        : cards.where((card) => card.name.toLowerCase().contains(term) || card.symbol.toLowerCase().contains(term));
    return filtered.toList()..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'Invest',
      body: ref.watch(collectionProvider).when(
        skipError: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ErrorView(
          message: apiErrorMessage(error),
          onRetry: () => ref.invalidate(collectionProvider),
        ),
        data: (owned) {
          final cards = _filter([for (final ownedAsset in owned) ownedAsset.asset]);

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            children: [
              const FadeSlideIn(child: _Intro()),
              const SizedBox(height: 20),
              if (owned.isEmpty)
                const _EmptyCollection()
              else ...[
                TextField(
                  onChanged: (value) => setState(() => _search = value),
                  decoration: const InputDecoration(
                    hintText: 'Search a card you own',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 16),
                if (cards.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text('No card matches "${_search.trim()}".', textAlign: .center),
                  ),
                for (final (index, card) in cards.indexed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: FadeSlideIn(
                      index: index + 1,
                      child: _AssetTile(card: card, onTap: () => context.push('/invest/simulate', extra: card)),
                    ),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF159B61), Color(0xFF0E6B5C)],
        ),
        boxShadow: [BoxShadow(color: AppColors.positive.withValues(alpha: 0.3), blurRadius: 24, offset: const Offset(0, 10))],
      ),
      child: const Row(
        spacing: 16,
        children: [
          Icon(Icons.history_toggle_off, color: Colors.white, size: 44),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              spacing: 4,
              children: [
                Text('Investment time machine', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: .w900)),
                Text(
                  'What if you had invested in one of your cards a few years ago? Pick a card to find out.',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AssetTile extends StatelessWidget {
  final Asset card;
  final VoidCallback onTap;

  const _AssetTile({required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            spacing: 14,
            children: [
              AppNetworkImage(url: card.logoUrl, size: 44),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: 2,
                  children: [
                    Text(
                      card.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16, fontWeight: .w800),
                    ),
                    Text('${card.symbol} · ${card.type}', style: const TextStyle(color: AppColors.muted, fontSize: 13)),
                  ],
                ),
              ),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: card.rarity.color, shape: BoxShape.circle),
              ),
              const Icon(Icons.chevron_right, color: AppColors.indigo),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyCollection extends StatelessWidget {
  const _EmptyCollection();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      children: [
        const SizedBox(height: 24),
        const Icon(Icons.style_outlined, size: 48, color: AppColors.muted),
        const Text(
          'You can only invest in cards you own.\nOpen packs to grow your collection!',
          textAlign: .center,
          style: TextStyle(color: AppColors.muted),
        ),
        OutlinedButton(onPressed: () => context.go('/home'), child: const Text('Go to my packs')),
      ],
    );
  }
}
