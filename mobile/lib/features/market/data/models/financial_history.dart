class FinancialHistoryPoint {
  final DateTime timestamp;
  final double price;

  const FinancialHistoryPoint({required this.timestamp, required this.price});

  factory FinancialHistoryPoint.fromJson(Map<String, dynamic> json) {
    return FinancialHistoryPoint(
      timestamp: DateTime.parse(json['timestamp'] as String),
      price: (json['price'] as num).toDouble(),
    );
  }
}

class FinancialHistory {
  final String financialAssetId;
  final String symbol;
  final String? currency;
  final List<FinancialHistoryPoint> points;
  final DateTime? fetchedAt;

  const FinancialHistory({
    required this.financialAssetId,
    required this.symbol,
    required this.points,
    this.currency,
    this.fetchedAt,
  });

  factory FinancialHistory.fromJson(Map<String, dynamic> json, {DateTime? fetchedAt}) {
    final rawPoints = json['points'] as List<dynamic>? ?? const [];

    return FinancialHistory(
      financialAssetId: json['financialAssetId'] as String,
      symbol: json['symbol'] as String,
      currency: json['currency'] as String?,
      fetchedAt: fetchedAt,
      points: rawPoints
          .map((p) => FinancialHistoryPoint.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }
}
