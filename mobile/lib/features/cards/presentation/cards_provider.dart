import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/cards/data/asset_repository.dart';
import 'package:mobile/features/cards/data/models/asset.dart';
import 'package:mobile/features/cards/presentation/card_query.dart';
import 'package:mobile/features/player/presentation/player_providers.dart';

enum CardsView { owned, all }

final assetsProvider = FutureProvider.autoDispose<List<Asset>>(
  (ref) => ref.watch(assetRepositoryProvider).getAssets(),
);

final cardQueryProvider = NotifierProvider.autoDispose<CardQueryNotifier, CardQuery>(CardQueryNotifier.new);

class CardQueryNotifier extends Notifier<CardQuery> {
  @override
  CardQuery build() => const CardQuery();

  void setSearch(String search) => state = state.copyWith(search: search);

  void setSort(CardSort sort) => state = state.copyWith(sort: sort);
}

final cardsViewProvider = NotifierProvider.autoDispose<CardsViewNotifier, CardsView>(CardsViewNotifier.new);

class CardsViewNotifier extends Notifier<CardsView> {
  @override
  CardsView build() => CardsView.owned;

  void select(CardsView view) => state = view;
}

final ownedAssetIdsProvider = Provider.autoDispose<AsyncValue<Set<int>>>(
  (ref) => ref.watch(collectionProvider).whenData((owned) => {for (final ownedAsset in owned) ownedAsset.asset.id}),
);

final visibleCardsProvider = Provider.autoDispose<AsyncValue<List<Asset>>>((ref) {
  final query = ref.watch(cardQueryProvider);
  final source = switch (ref.watch(cardsViewProvider)) {
    CardsView.owned => ref.watch(collectionProvider).whenData((owned) => [for (final ownedAsset in owned) ownedAsset.asset]),
    CardsView.all => ref.watch(assetsProvider),
  };
  return source.whenData(query.apply);
});
