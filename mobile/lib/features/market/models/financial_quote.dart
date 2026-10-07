class FinancialQuote {
  final String financialAssetId;

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

  const FinancialQuote({
    required this.financialAssetId,
    required this.symbol,
    required this.name,
    required this.assetType,

    required this.currency,
    required this.exchange,

    required this.price,
    required this.open,
    required this.high,
    required this.low,
    required this.previousClose,
    required this.change,
    required this.changePercent,
    required this.volume,
    required this.marketOpen,
    required this.timestamp,
    required this.provider,
  });

  factory FinancialQuote.fromJson(
      Map<String, dynamic> json,
      ) {
    return FinancialQuote(
      financialAssetId:
      json['financialAssetId'] as String,

      symbol:
      json['symbol'] as String,

      name:
      json['name'] as String,

      assetType:
      json['assetType'] as String,

      currency:
      json['currency'] as String?,

      exchange:
      json['exchange'] as String?,

      price:
      _toDouble(json['price']) ?? 0,

      open:
      _toDouble(json['open']),

      high:
      _toDouble(json['high']),

      low:
      _toDouble(json['low']),

      previousClose:
      _toDouble(
        json['previousClose'],
      ),

      change:
      _toDouble(json['change']),

      changePercent:
      _toDouble(
        json['changePercent'],
      ),

      volume:
      _toDouble(json['volume']),

      marketOpen:
      json['marketOpen'] as bool? ??
          false,

      timestamp:
      json['timestamp'] == null
          ? null
          : DateTime.parse(
        json['timestamp']
        as String,
      ),

      provider:
      json['provider'] as String? ??
          '',
    );
  }

  static double? _toDouble(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value.toString(),
    );
  }
}