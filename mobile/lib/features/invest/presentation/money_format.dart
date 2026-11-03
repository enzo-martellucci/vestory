String formatEuros(double value, {bool signed = false}) {
  final rounded = value.abs().round().toString();
  final grouped = rounded.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ' ');
  final sign = value < 0 ? '-' : (signed && value > 0 ? '+' : '');
  return '$sign$grouped €';
}

String formatPercent(double ratio, {bool signed = true}) {
  final percent = (ratio * 100).toStringAsFixed(1);
  return signed && ratio > 0 ? '+$percent %' : '$percent %';
}
