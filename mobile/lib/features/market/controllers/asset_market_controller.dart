import 'package:flutter/foundation.dart';

import '../../../core/state/async_value.dart';
import '../models/financial_history.dart';
import '../models/financial_quote.dart';
import '../repositories/market_repository.dart';

class AssetMarketController extends ChangeNotifier {
  final MarketRepository _repository;
  final String financialAssetId;

  AssetMarketController(this._repository, this.financialAssetId);

  AsyncValue<FinancialQuote>? _quote;
  AsyncValue<FinancialQuote>? get quote => _quote;

  AsyncValue<FinancialHistory>? _history;
  AsyncValue<FinancialHistory>? get history => _history;

  bool _disposed = false;

  void ensureLoaded() {
    if (_quote == null || _quote is AsyncError) _loadQuote();
    if (_history == null || _history is AsyncError) _loadHistory();
  }

  Future<void> _loadQuote() async {
    _quote = const AsyncLoading();
    _notify();
    _quote = await guardAsync(() => _repository.getQuote(financialAssetId));
    _notify();
  }

  Future<void> _loadHistory() async {
    _history = const AsyncLoading();
    _notify();
    _history =
        await guardAsync(() => _repository.getHistory(financialAssetId));
    _notify();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
