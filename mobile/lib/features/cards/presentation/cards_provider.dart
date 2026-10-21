import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/cards/data/card_repository.dart';
import 'package:mobile/features/cards/data/models/asset_card_model.dart';

final cardsProvider = FutureProvider.autoDispose<List<AssetCardModel>>(
  (ref) => ref.watch(cardRepositoryProvider).getCards(),
);
