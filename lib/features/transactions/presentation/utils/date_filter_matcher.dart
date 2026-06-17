import 'package:peso_path/features/transactions/presentation/utils/date_filter_range.dart';

bool isTransactionInTimeRange(DateTime txDate, DateFilterRange range) {
  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day);
  final yesterdayStart = todayStart.subtract(const Duration(days: 1));

  switch (range) {
    case DateFilterRange.all:
      return true;
    case DateFilterRange.today:
      return txDate.isAfter(todayStart) || txDate.isAtSameMomentAs(todayStart);
    case DateFilterRange.yesterday:
      return (txDate.isAfter(yesterdayStart) ||
              txDate.isAtSameMomentAs(yesterdayStart)) &&
          txDate.isBefore(todayStart);
    case DateFilterRange.thisWeek:
      final daysToSubtract = now.weekday - DateTime.monday;
      final weekStart = todayStart.subtract(Duration(days: daysToSubtract));
      return txDate.isAfter(weekStart) || txDate.isAtSameMomentAs(weekStart);
    case DateFilterRange.thisMonth:
      final monthStart = DateTime(now.year, now.month, 1);
      return txDate.isAfter(monthStart) || txDate.isAtSameMomentAs(monthStart);
    case DateFilterRange.lastMonth:
      final firstDayOfLastMonth = DateTime(now.year, now.month - 1, 1);
      final lastDayOfLastMonth = DateTime(
        now.year,
        now.month,
        1,
      ).subtract(const Duration(microseconds: 1));
      return (txDate.isAfter(firstDayOfLastMonth) ||
              txDate.isAtSameMomentAs(firstDayOfLastMonth)) &&
          txDate.isBefore(lastDayOfLastMonth);
  }
}
