import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/cards/data/card_repository.dart';
import 'package:mobile/features/cards/data/models/asset_card_model.dart';
import 'package:mobile/features/cards/presentation/card_query.dart';

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

final visibleCardsProvider = Provider.autoDispose<AsyncValue<List<AssetCardModel>>>((ref) {
  final query = ref.watch(cardQueryProvider);
  return ref.watch(cardsProvider).whenData(query.apply);
});
