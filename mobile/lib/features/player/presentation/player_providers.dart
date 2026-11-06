import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/features/player/data/player_repository.dart';

final playerProvider = StreamProvider<Player?>((ref) => ref.watch(playerRepositoryProvider).watch());
