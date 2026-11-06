import 'package:mobile/core/time/clock.dart';
import 'package:mobile/features/packs/domain/pack_type.dart';

const dailyPackType = PackType.standard;

bool isDailyPackAvailable(DateTime? lastClaimedAt, DateTime now) =>
    lastClaimedAt == null || calendarDaysBetween(lastClaimedAt, now) > 0;

DateTime nextDailyPackAt(DateTime now) => DateTime(now.year, now.month, now.day + 1);
