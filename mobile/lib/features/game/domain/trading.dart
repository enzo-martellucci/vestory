const quantityTolerance = 1e-9;
const cashTolerance = 1e-6;

class TradeException implements Exception {
  final String message;

  const TradeException(this.message);

  @override
  String toString() => message;
}

double buyQuantity({required double amount, required double cash, required double? price}) {
  if (price == null || price <= 0)
    throw const TradeException('This asset was not listed yet at this date.');
  if (amount <= 0)
    throw const TradeException('Enter an amount greater than zero.');
  if (amount > cash + cashTolerance)
    throw const TradeException('Not enough cash for this order.');
  return amount / price;
}

double sellProceeds({required double quantity, required double held, required double? price}) {
  if (price == null || price <= 0)
    throw const TradeException('No price available at this date.');
  if (quantity <= 0)
    throw const TradeException('Enter a quantity greater than zero.');
  if (quantity > held + quantityTolerance)
    throw const TradeException('You cannot sell more than you hold.');
  return quantity * price;
}
