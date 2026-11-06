import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/page_insets.dart';
import 'package:mobile/core/widgets/panel.dart';
import 'package:mobile/features/assets/domain/asset_search.dart';
import 'package:mobile/features/assets/presentation/asset_card.dart';
import 'package:mobile/features/market/presentation/asset_detail_sheet.dart';
import 'package:mobile/features/assets/presentation/asset_providers.dart';

enum CollectionSort {
  number('Number'),
  name('Name'),
  rarity('Rarity');

  final String label;

  const CollectionSort(this.label);
}

class CollectionScreen extends ConsumerStatefulWidget {
  const CollectionScreen({super.key});

  @override
  ConsumerState<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends ConsumerState<CollectionScreen> {
  var _ownedOnly = true;
  var _search = '';
  var _sort = CollectionSort.number;

  List<Asset> _visible(List<Asset> assets) {
    final visible = [
      for (final asset in assets)
        if ((!_ownedOnly || asset.quantity > 0) && asset.matches(_search))
          asset,
    ];
    return visible..sort(switch (_sort) {
      CollectionSort.number => (a, b) => a.id.compareTo(b.id),
      CollectionSort.name => (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      CollectionSort.rarity => (a, b) => b.rarity.index != a.rarity.index ? b.rarity.index.compareTo(a.rarity.index) : a.id.compareTo(b.id),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Collection')),
      body: ref.watch(assetsProvider).when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: ErrorView(error: error)),
        data: (assets) {
          final owned = assets.where((asset) => asset.quantity > 0).length;
          final visible = _visible(assets);
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _Progress(owned: owned, total: assets.length),
                      const SizedBox(height: 16),
                      TextField(
                        decoration: const InputDecoration(hintText: 'Search a name or a symbol', prefixIcon: Icon(Icons.search_rounded)),
                        onChanged: (value) => setState(() => _search = value),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          SegmentedButton<bool>(
                            segments: const [
                              ButtonSegment(value: true, label: Text('Owned')),
                              ButtonSegment(value: false, label: Text('All')),
                            ],
                            selected: {_ownedOnly},
                            showSelectedIcon: false,
                            onSelectionChanged: (selection) => setState(() => _ownedOnly = selection.single),
                          ),
                          const Spacer(),
                          PopupMenuButton<CollectionSort>(
                            initialValue: _sort,
                            onSelected: (sort) => setState(() => _sort = sort),
                            itemBuilder: (context) => [
                              for (final sort in CollectionSort.values) PopupMenuItem(value: sort, child: Text(sort.label)),
                            ],
                            child: Chip(avatar: const Icon(Icons.sort_rounded, size: 18), label: Text(_sort.label)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (visible.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      _ownedOnly && _search.isEmpty ? 'No cards yet.\nOpen packs to start your collection!' : 'No card matches your search.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.muted),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: pageInsets(context, top: 4),
                  sliver: SliverGrid.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: assetCardAspectRatio,
                    ),
                    itemCount: visible.length,
                    itemBuilder: (context, index) {
                      final asset = visible[index];
                      return asset.quantity > 0
                          ? FlippableAssetCard(
                              key: ValueKey(asset.id),
                              asset: asset,
                              total: assets.length,
                              onDetails: () => showAssetDetailSheet(context, asset),
                            )
                          : LockedAssetCard(key: ValueKey(asset.id), asset: asset);
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Progress extends StatelessWidget {
  final int owned;
  final int total;

  const _Progress({required this.owned, required this.total});

  @override
  Widget build(BuildContext context) {
    return Panel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Collection progress', style: TextStyle(fontWeight: FontWeight.w700)),
              const Spacer(),
              Text('$owned / $total', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: total == 0 ? 0 : owned / total),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) => LinearProgressIndicator(value: value, minHeight: 10, backgroundColor: AppColors.primarySoft),
            ),
          ),
        ],
      ),
    );
  }
}
