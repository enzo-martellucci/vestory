# Vestory — mobile

Application mobile Flutter de Vestory : une collection de cartes d'actifs
financiers, retournables pour voir la cotation et l'historique.

## Lancer

```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080   # émulateur Android
flutter test
flutter analyze
```

## Architecture

Organisation **feature-first**, en couches. Les dépendances vont toujours
dans le même sens : `UI → controller → repository (interface) → ApiClient`.

```
lib/
├── main.dart                  # point d'entrée, ne fait que runApp
├── app/
│   ├── app_dependencies.dart  # composition root + AppScope (InheritedWidget)
│   └── vestory_app.dart       # MaterialApp, thème, page d'accueil
├── core/                      # transverse, ne dépend d'AUCUNE feature
│   ├── api/                   # ApiClient (Dio générique) + ApiException
│   ├── state/async_value.dart # AsyncLoading / AsyncData / AsyncError
│   ├── theme/                 # AppColors, AppTheme
│   └── widgets/               # FlipCard, AppNetworkImage
└── features/
    ├── cards/
    │   ├── models/            # AssetCardModel, CardRarity (enum)
    │   ├── repositories/      # CardRepository (interface) + ApiCardRepository
    │   ├── controllers/       # CardsController (ChangeNotifier)
    │   ├── pages/             # CardsPage
    │   └── widgets/           # AssetCard, CardFrame, recto/, verso/
    └── market/
        ├── models/            # FinancialQuote, FinancialHistory
        ├── repositories/      # MarketRepository + Api… + CachedMarketRepository
        └── controllers/       # AssetMarketController (données d'un actif)
```

### Règles

- **`core` ne connaît pas les features.** Le parsing JSON se fait dans le
  repository de chaque feature, pas dans `ApiClient`.
- **L'UI dépend d'interfaces** (`CardRepository`, `MarketRepository`) ;
  les implémentations sont choisies dans `AppDependencies.production()`.
  Les tests injectent des fakes via `AppDependencies(...)`.
- **Pas de logique réseau dans les widgets** : un widget lit un controller
  (`ListenableBuilder`) qui expose des `AsyncValue<T>`.
- **Pas de couleur en dur** : utiliser `AppColors` ; la couleur de rareté
  vient de `CardRarity.color`.
- Les données de marché passent par `CachedMarketRepository`
  (cotation 1 min, historique 15 min, requêtes dédoublonnées).

### Ajouter une feature

1. `features/<nom>/models` + `repositories/<nom>_repository.dart`
   (interface + implémentation `Api…`).
2. L'enregistrer dans `AppDependencies`.
3. Un controller `ChangeNotifier` exposant des `AsyncValue`.
4. Une page qui crée le controller depuis `AppScope.of(context)`.
