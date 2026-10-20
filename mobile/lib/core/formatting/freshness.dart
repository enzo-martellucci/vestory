String freshnessLabel(DateTime fetchedAt, DateTime now) {
  final local = fetchedAt.toLocal();
  final time = '${_twoDigits(local.hour)}:${_twoDigits(local.minute)}';
  if (isSameDay(local, now.toLocal())) return 'Updated today at $time';
  return 'Updated on ${_twoDigits(local.day)}/${_twoDigits(local.month)} at $time';
}

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String _twoDigits(int value) => value.toString().padLeft(2, '0');