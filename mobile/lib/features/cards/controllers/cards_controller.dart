import 'package:flutter/foundation.dart';

import '../../../core/state/async_value.dart';
import '../models/asset_card_model.dart';
import '../repositories/card_repository.dart';

class CardsController extends ChangeNotifier {
  final CardRepository _repository;

  CardsController(this._repository);

  AsyncValue<List<AssetCardModel>> _state = const AsyncLoading();
  AsyncValue<List<AssetCardModel>> get state => _state;

  bool _disposed = false;

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

  void _setState(AsyncValue<List<AssetCardModel>> value) {
    if (_disposed) return;
    _state = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
