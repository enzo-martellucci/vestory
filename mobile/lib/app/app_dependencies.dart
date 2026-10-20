import 'package:flutter/widgets.dart';
import '../core/cache/json_cache.dart';
import '../core/database/app_database.dart';
import '../core/api/api_client.dart';
import '../features/cards/repositories/card_repository.dart';
import '../features/market/repositories/market_repository.dart';

/// Conteneur des dépendances de l'application (composition root).
///
/// Toutes les instances partagées sont créées une seule fois ici.
/// Pour les tests, on construit un `AppDependencies` avec des fakes.
class AppDependencies {
  final CardRepository cardRepository;
  final MarketRepository marketRepository;

  const AppDependencies({
    required this.cardRepository,
    required this.marketRepository,
  });

  factory AppDependencies.production() {
    final apiClient = ApiClient();
    final database = AppDatabase();
    return AppDependencies(
      cardRepository: ApiCardRepository(apiClient),
      marketRepository: OfflineFirstMarketRepository(
        apiClient,
        DriftJsonCache(database),
      ),
    );
  }
}

/// Expose [AppDependencies] à tout l'arbre de widgets.
///
/// Évite de faire transiter les repositories de constructeur en
/// constructeur (main → page → carte → ...).
class AppScope extends InheritedWidget {
  final AppDependencies dependencies;

  const AppScope({
    super.key,
    required this.dependencies,
    required super.child,
  });

  static AppDependencies of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'No AppScope found in the widget tree.');
    return scope!.dependencies;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) =>
      dependencies != oldWidget.dependencies;
}
