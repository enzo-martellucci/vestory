import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/market/data/market_repository.dart';
import 'package:mobile/features/market/data/models/financial_history.dart';
import 'package:mobile/features/market/data/models/financial_quote.dart';

final quoteProvider = FutureProvider.autoDispose.family<FinancialQuote, String>(
  (ref, financialAssetId) => ref.watch(marketRepositoryProvider).getQuote(financialAssetId),
);

final historyProvider = FutureProvider.autoDispose.family<FinancialHistory, String>(
  (ref, financialAssetId) => ref.watch(marketRepositoryProvider).getHistory(financialAssetId),
);
