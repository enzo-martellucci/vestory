import 'package:mobile/features/cards/data/models/asset.dart';

enum CardSort {
  collectionNumber('Collection number'),
  name('Name (A-Z)'),
  rarity('Rarity');

  final String label;

  const CardSort(this.label);
}

class CardQuery {
  final String search;
  final CardSort sort;

  const CardQuery({this.search = '', this.sort = CardSort.collectionNumber});

  CardQuery copyWith({String? search, CardSort? sort}) =>
      CardQuery(search: search ?? this.search, sort: sort ?? this.sort);

  List<Asset> apply(List<Asset> cards) {
    final term = search.trim().toLowerCase();
    final filtered = term.isEmpty
        ? List.of(cards)
        : cards
            .where((card) => card.name.toLowerCase().contains(term) || card.symbol.toLowerCase().contains(term))
            .toList();

    filtered.sort(switch (sort) {
      CardSort.collectionNumber => (a, b) => a.id.compareTo(b.id),
      CardSort.name => (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      CardSort.rarity => (a, b) {
        final byRarity = b.rarity.index.compareTo(a.rarity.index);
        return byRarity != 0 ? byRarity : a.id.compareTo(b.id);
      },
    });

    return filtered;
  }
}
