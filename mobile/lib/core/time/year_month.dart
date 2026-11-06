class YearMonth implements Comparable<YearMonth> {
  static const _monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  final int year;
  final int month;

  const YearMonth(this.year, this.month);

  factory YearMonth.fromIndex(int index) => YearMonth(index ~/ 12, index % 12 + 1);

  factory YearMonth.of(DateTime date) => YearMonth(date.year, date.month);

  factory YearMonth.parse(String value) => YearMonth(int.parse(value.substring(0, 4)), int.parse(value.substring(5, 7)));

  int get index => year * 12 + month - 1;

  String get label => '${_monthNames[month - 1]} $year';

  YearMonth plus(int months) => YearMonth.fromIndex(index + months);

  int monthsUntil(YearMonth other) => other.index - index;

  bool isBefore(YearMonth other) => index < other.index;

  bool isAfter(YearMonth other) => index > other.index;

  @override
  int compareTo(YearMonth other) => index.compareTo(other.index);

  @override
  bool operator ==(Object other) => other is YearMonth && other.index == index;

  @override
  int get hashCode => index;

  @override
  String toString() => '$year-${month.toString().padLeft(2, '0')}';
}
