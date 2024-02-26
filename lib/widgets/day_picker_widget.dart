import 'package:flutter/material.dart';
import 'package:flutter_calendar_1_17_4/utils/date_utils.dart';
import 'package:flutter_calendar_1_17_4/widgets/day_widget.dart';
import 'package:flutter_calendar_1_17_4/widgets/enum/day_status.dart';

class DayPickerWidget extends StatefulWidget {
  const DayPickerWidget({
    @required this.currentDate,
    @required this.onChanged,
    @required this.displayedMonth,
    this.selectedDate,
    Key key,
  });

  final DateTime selectedDate;

  final DateTime currentDate;

  final ValueChanged<DateTime> onChanged;

  final DateTime displayedMonth;

  @override
  State<DayPickerWidget> createState() => _DayPickerWidgetState();
}

class _DayPickerWidgetState extends State<DayPickerWidget> {
  final _monthPickerHorizontalPadding = 8.0;

  final abbreviationDaysWeek = [
    'DOM.',
    'SEG.',
    'TER.',
    'QUA.',
    'QUI.',
    'SEX',
    'SÁB.'
  ];

  List<Widget> _dayHeaders(
      TextStyle headerStyle, MaterialLocalizations localizations) {
    final List<Widget> result = <Widget>[];
    for (int i = localizations.firstDayOfWeekIndex;
        result.length < DateTime.daysPerWeek;
        i = (i + 1) % DateTime.daysPerWeek) {
      // final String weekday = localizations.narrowWeekdays[i];
      final String weekday = abbreviationDaysWeek[i];
      result.add(
        Center(child: Text(weekday, style: headerStyle)),
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);

    final int year = widget.displayedMonth.year;
    final int month = widget.displayedMonth.month;

    final int daysInMonth = DateUtils.getDaysInMonth(year, month);
    final int dayOffset = DateUtils.firstDayOffset(year, month, localizations);

    const weekdayStyle = TextStyle(
      color: Colors.grey,
      fontSize: 14,
    );

    final List<Widget> dayItems = _dayHeaders(weekdayStyle, localizations);

    int day = -dayOffset;
    while (day < daysInMonth) {
      day++;
      if (day < 1) {
        dayItems.add(const SizedBox.shrink());
      } else {
        final dayToBuild = DateTime(year, month, day);

        final bool isSelectedDay =
            DateUtils.isSameDay(widget.selectedDate, dayToBuild);
        final bool isToday =
            DateUtils.isSameDay(widget.currentDate, dayToBuild);

        final bool isDisabled = dayToBuild.isBefore(widget.currentDate);

        final dayStatus = _getDayStatus(isDisabled, isSelectedDay, isToday);

        dayItems.add(
          DayWidget(
            day: dayToBuild,
            dayStatus: dayStatus,
            onChanged: (value) {
              widget.onChanged(value);
            },
          ),
        );
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _monthPickerHorizontalPadding,
      ),
      child: GridView.custom(
        physics: const ClampingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: DateTime.daysPerWeek,
        ),
        childrenDelegate: SliverChildListDelegate(
          dayItems,
          addRepaintBoundaries: false,
        ),
      ),
    );
  }

  DayStatus _getDayStatus(bool isDisabled, bool isSelectedDay, bool isToday) {
    if (isSelectedDay) {
      return DayStatus.isSelectedDay;
    }
    if (isToday) {
      return DayStatus.isToday;
    }

    if (isDisabled) {
      return DayStatus.isDisabled;
    }

    return DayStatus.none;
  }
}
