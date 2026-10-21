import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/cards/data/card_repository.dart';
import 'package:mobile/features/cards/data/models/asset_card_model.dart';
import 'package:mobile/features/cards/presentation/card_query.dart';
import 'package:mobile/features/player/presentation/player_providers.dart';

enum CardsView { owned, all }

final cardsProvider = FutureProvider.autoDispose<List<AssetCardModel>>(
  (ref) => ref.watch(cardRepositoryProvider).getCards(),
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

final ownedCardIdsProvider = Provider.autoDispose<AsyncValue<Set<String>>>(
  (ref) => ref.watch(collectionProvider).whenData((owned) => {for (final ownedCard in owned) ownedCard.card.id}),
);

final visibleCardsProvider = Provider.autoDispose<AsyncValue<List<AssetCardModel>>>((ref) {
  final query = ref.watch(cardQueryProvider);
  final source = switch (ref.watch(cardsViewProvider)) {
    CardsView.owned => ref.watch(collectionProvider).whenData((owned) => [for (final ownedCard in owned) ownedCard.card]),
    CardsView.all => ref.watch(cardsProvider),
  };
  return source.whenData(query.apply);
});
