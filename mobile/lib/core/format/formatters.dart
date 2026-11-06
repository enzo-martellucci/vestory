final _thousands = RegExp(r'\B(?=(\d{3})+(?!\d))');

String _groupThousands(String digits) => digits.replaceAllMapped(_thousands, (_) => ',');

String formatMoney(double value) {
  final parts = value.abs().toStringAsFixed(2).split('.');
  return '${value < 0 ? '-' : ''}\$${_groupThousands(parts[0])}.${parts[1]}';
}

String formatSignedMoney(double value) => '${value >= 0 ? '+' : ''}${formatMoney(value)}';

String formatPrice(double value) => value >= 1 ? formatMoney(value) : '\$${value.toStringAsFixed(4)}';

String formatPercent(double ratio) => '${ratio >= 0 ? '+' : ''}${(ratio * 100).toStringAsFixed(2)}%';

String formatGems(int value) => _groupThousands(value.toString());

String formatQuantity(double value) {
  final decimals = value >= 100 ? 2 : value >= 1 ? 4 : 6;
  return value.toStringAsFixed(decimals).replaceFirst(RegExp(r'\.?0+$'), '');
}

String formatCountdown(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  return hours > 0 ? '${hours}h ${minutes.toString().padLeft(2, '0')}m' : '${minutes}m';
}
