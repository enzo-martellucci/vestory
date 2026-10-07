class FinancialHistoryPoint {
  final DateTime timestamp;
  final double price;

  const FinancialHistoryPoint({
    required this.timestamp,
    required this.price,
  });

  factory FinancialHistoryPoint.fromJson(
      Map<String, dynamic> json,
      ) {
    return FinancialHistoryPoint(
      timestamp: DateTime.parse(
        json['timestamp'] as String,
      ),
      price: (json['price'] as num).toDouble(),
    );
  }
}

class FinancialHistory {
  final String financialAssetId;
  final String symbol;
  final String? currency;

  final List<FinancialHistoryPoint> points;

  const FinancialHistory({
    required this.financialAssetId,
    required this.symbol,
    required this.currency,
    required this.points,
  });

  factory FinancialHistory.fromJson(
      Map<String, dynamic> json,
      ) {
    final rawPoints =
        json['points'] as List<dynamic>? ?? [];

    return FinancialHistory(
      financialAssetId:
      json['financialAssetId'] as String,

      symbol:
      json['symbol'] as String,

      currency:
      json['currency'] as String?,

      points: rawPoints
          .map(
            (point) =>
            FinancialHistoryPoint.fromJson(
              point as Map<String, dynamic>,
            ),
      )
          .toList(),
    );
  }
}