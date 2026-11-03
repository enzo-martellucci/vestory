import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/invest/presentation/money_format.dart';

void main() {
  test('euros are rounded and grouped by thousands', () {
    expect(formatEuros(1234567.6), '1 234 568 €');
    expect(formatEuros(950), '950 €');
    expect(formatEuros(-1500), '-1 500 €');
    expect(formatEuros(250, signed: true), '+250 €');
  });

  test('percents keep one decimal and a sign', () {
    expect(formatPercent(0.1234), '+12.3 %');
    expect(formatPercent(-0.05), '-5.0 %');
    expect(formatPercent(0.2, signed: false), '20.0 %');
  });
}
