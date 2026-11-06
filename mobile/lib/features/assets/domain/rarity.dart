enum Rarity {
  common('Common', 2),
  rare('Rare', 10),
  epic('Epic', 50),
  legendary('Legendary', 100);

  final String label;
  final int duplicateGems;

  const Rarity(this.label, this.duplicateGems);
}
