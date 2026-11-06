import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/assets/data/asset_repository.dart';
import 'package:mobile/features/market/data/market_repository.dart';
import 'package:mobile/features/market/domain/price_history.dart';
import 'package:mobile/features/market/domain/quote.dart';

final priceHistoryProvider = FutureProvider.family<PriceHistory, int>((ref, assetId) async {
  final asset = await ref.read(assetRepositoryProvider).findById(assetId);
  return ref.read(marketRepositoryProvider).history(asset);
});

final quoteProvider = FutureProvider.autoDispose.family<Quote, int>((ref, assetId) async {
  final asset = await ref.read(assetRepositoryProvider).findById(assetId);
  return ref.read(marketRepositoryProvider).quote(asset);
});
