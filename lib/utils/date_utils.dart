import 'package:flutter/material.dart';

class DateUtils {
  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static _DateTimeRange datesOnly(_DateTimeRange range) {
    return _DateTimeRange(
        start: dateOnly(range.start), end: dateOnly(range.end));
  }

  static bool isSameDay(DateTime dateA, DateTime dateB) {
    return dateA?.year == dateB?.year &&
        dateA?.month == dateB?.month &&
        dateA?.day == dateB?.day;
  }

  static bool isSameMonth(DateTime dateA, DateTime dateB) {
    return dateA?.year == dateB?.year && dateA?.month == dateB?.month;
  }

  static int monthDelta(DateTime startDate, DateTime endDate) {
    return (endDate.year - startDate.year) * 12 +
        endDate.month -
        startDate.month;
  }

  static DateTime addMonthsToMonthDate(DateTime monthDate, int monthsToAdd) {
    return DateTime(monthDate.year, monthDate.month + monthsToAdd);
  }

  static DateTime addDaysToDate(DateTime date, int days) {
    return DateTime(date.year, date.month, date.day + days);
  }

  static int firstDayOffset(
      int year, int month, MaterialLocalizations localizations) {
    final int weekdayFromMonday = DateTime(year, month).weekday - 1;

    int firstDayOfWeekIndex = localizations.firstDayOfWeekIndex;

    firstDayOfWeekIndex = (firstDayOfWeekIndex - 1) % 7;

    return (weekdayFromMonday - firstDayOfWeekIndex) % 7;
  }

  static int getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      final bool isLeapYear =
          (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      return isLeapYear ? 29 : 28;
    }
    const List<int> daysInMonth = <int>[
      31,
      -1,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];
    return daysInMonth[month - 1];
  }
}

class _DateTimeRange {
  _DateTimeRange({
    @required this.start,
    @required this.end,
  }) : assert(!start.isAfter(end));

  final DateTime start;

  final DateTime end;

  Duration get duration => end.difference(start);

  @override
  bool operator ==(covariant _DateTimeRange other) {
    if (identical(this, other)) return true;

    return other.start == start && other.end == end;
  }

  @override
  String toString() => '$start - $end';

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}
