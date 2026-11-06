enum AssetType {
  stock('Stock'),
  etf('ETF'),
  crypto('Crypto'),
  forex('Forex'),
  commodity('Commodity');

  final String label;

  const AssetType(this.label);
}
