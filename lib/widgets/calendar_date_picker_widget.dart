import 'dart:core';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_1_17_4/widgets/month_picker_widget.dart';

Future<DateTime> showDatePickerBottomSheet(
  BuildContext context,
) {
  return showModalBottomSheet<DateTime>(
    context: context,
    builder: (context) {
      return CalendarDatePickerWidget(
        firstDate: DateTime.now(),
        lastDate: DateTime(2041),
        currentDate: DateTime.now(),
        onDateChanged: (date) {
          log('$date');
        },
        onDisplayedMonthChanged: (date) {
          log('$date');
        },
        initialDate: DateTime.now(),
        selectableDayPredicate: (day) {
          return day.isAfter(DateTime.now());
        },
      );
    },
  );
}

class CalendarDatePickerWidget extends StatefulWidget {
  const CalendarDatePickerWidget({
    @required this.firstDate,
    @required this.lastDate,
    @required this.currentDate,
    @required this.onDateChanged,
    this.initialDate,
    this.onDisplayedMonthChanged,
    this.selectableDayPredicate,
    Key key,
  });

  final DateTime initialDate;

  final DateTime firstDate;

  final DateTime lastDate;

  final DateTime currentDate;

  final ValueChanged<DateTime> onDateChanged;

  final ValueChanged<DateTime> onDisplayedMonthChanged;

  final SelectableDayPredicate selectableDayPredicate;

  @override
  State<CalendarDatePickerWidget> createState() =>
      _CalendarDatePickerWidgetState();
}

class _CalendarDatePickerWidgetState extends State<CalendarDatePickerWidget> {
  DateTime _selectedDate;
  DateTime _currentDisplayedMonthDate;

  void _handleMonthChanged(DateTime date) {
    setState(() {
      if (_currentDisplayedMonthDate.year != date.year ||
          _currentDisplayedMonthDate.month != date.month) {
        _currentDisplayedMonthDate = DateTime(date.year, date.month);
        widget.onDisplayedMonthChanged.call(_currentDisplayedMonthDate);
      }
    });
  }

  void _handleDayChanged(DateTime value) {
    // _vibrate();
    setState(() {
      _selectedDate = value;
      widget.onDateChanged(_selectedDate);
    });
  }

  @override
  void initState() {
    super.initState();

    final DateTime currentDisplayedDate =
        widget.initialDate ?? widget.currentDate;
    _currentDisplayedMonthDate =
        DateTime(currentDisplayedDate.year, currentDisplayedDate.month);
    if (widget.initialDate != null) {
      _selectedDate = widget.initialDate ?? DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: MonthPickerWidget(
        currentDate: widget.currentDate,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
        onChanged: _handleDayChanged,
        onDisplayedMonthChanged: _handleMonthChanged,
        selectedDate: _selectedDate,
        selectableDayPredicate: (day) {
          return widget.selectableDayPredicate(day);
        },
      ),
    );
  }
}
