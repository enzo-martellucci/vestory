class FinancialQuote {
  final int financialAssetId;
  final String symbol;
  final String name;
  final String assetType;

  final String? currency;
  final String? exchange;

  final double price;
  final double? open;
  final double? high;
  final double? low;
  final double? previousClose;
  final double? change;
  final double? changePercent;
  final double? volume;

  final bool marketOpen;
  final DateTime? timestamp;
  final String provider;
  final String? trackedBy;
  final DateTime? fetchedAt;

  const FinancialQuote({
    required this.financialAssetId,
    required this.symbol,
    required this.name,
    required this.assetType,
    required this.price,
    this.currency,
    this.exchange,
    this.open,
    this.high,
    this.low,
    this.previousClose,
    this.change,
    this.changePercent,
    this.volume,
    this.marketOpen = false,
    this.timestamp,
    this.provider = '',
    this.trackedBy,
    this.fetchedAt,
  });

  bool get isPositive => (changePercent ?? 0) >= 0;

  factory FinancialQuote.fromJson(Map<String, dynamic> json, {DateTime? fetchedAt}) {    final price = _toDouble(json['price']);
    if (price == null) {
      throw const FormatException('Quote without price.');
    }

    final rawTimestamp = json['timestamp'] as String?;

    return FinancialQuote(
      financialAssetId: json['financialAssetId'] as int,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      assetType: json['assetType'] as String,
      currency: json['currency'] as String?,
      exchange: json['exchange'] as String?,
      price: price,
      open: _toDouble(json['open']),
      high: _toDouble(json['high']),
      low: _toDouble(json['low']),
      previousClose: _toDouble(json['previousClose']),
      change: _toDouble(json['change']),
      changePercent: _toDouble(json['changePercent']),
      volume: _toDouble(json['volume']),
      marketOpen: json['marketOpen'] as bool? ?? false,
      timestamp: rawTimestamp == null ? null : DateTime.tryParse(rawTimestamp),
      provider: json['provider'] as String? ?? '',
      trackedBy: json['trackedBy'] as String?,
      fetchedAt: fetchedAt,
    );
  }

  static double? _toDouble(dynamic value) => switch (value) {
        null => null,
        num n => n.toDouble(),
        _ => double.tryParse(value.toString()),
      };
}
