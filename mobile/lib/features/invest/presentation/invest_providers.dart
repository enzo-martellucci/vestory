import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/invest/data/invest_repository.dart';
import 'package:mobile/features/invest/data/models/price_point.dart';

final monthlyHistoryProvider = FutureProvider.autoDispose.family<List<PricePoint>, (String, int)>(
  (ref, request) => ref.watch(investRepositoryProvider).getMonthlyHistory(request.$1, request.$2),
);
