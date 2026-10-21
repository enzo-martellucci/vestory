import 'package:flutter/foundation.dart';

import '../../../core/state/async_value.dart';
import '../models/asset_card_model.dart';
import '../models/card_query.dart';
import '../repositories/card_repository.dart';

class CardsController extends ChangeNotifier {
  final CardRepository _repository;

  CardsController(this._repository);

  AsyncValue<List<AssetCardModel>> _state = const AsyncLoading();
  AsyncValue<List<AssetCardModel>> get state => _state;

  String _search = '';
  String get search => _search;

  CardSort _sort = CardSort.collectionNumber;
  CardSort get sort => _sort;

  bool _disposed = false;

  List<AssetCardModel> get visibleCards =>
      applyCardQuery(_state.valueOrNull ?? const [], search: _search, sort: _sort);

  Future<void> load() async {
    _setState(const AsyncLoading());
    _setState(await guardAsync(_repository.getCards));
  }

  Future<String?> refresh() async {
    final result = await guardAsync(_repository.getCards);
    if (result is AsyncError<List<AssetCardModel>> && _state is AsyncData) {
      return result.message;
    }
    _setState(result);
    return null;
  }

  void setSearch(String value) {
    if (value == _search) return;
    _search = value;
    _notify();
  }

  void setSort(CardSort value) {
    if (value == _sort) return;
    _sort = value;
    _notify();
  }

  void _setState(AsyncValue<List<AssetCardModel>> value) {
    _state = value;
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