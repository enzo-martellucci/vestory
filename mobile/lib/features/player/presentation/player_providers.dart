import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/player/data/models/owned_card.dart';
import 'package:mobile/features/player/data/models/player_profile.dart';
import 'package:mobile/features/player/data/player_repository.dart';

final playerProfileProvider = FutureProvider.autoDispose<PlayerProfile>(
  (ref) => ref.watch(playerRepositoryProvider).getProfile(),
);

final collectionProvider = FutureProvider.autoDispose<List<OwnedCard>>(
  (ref) => ref.watch(playerRepositoryProvider).getCollection(),
);
