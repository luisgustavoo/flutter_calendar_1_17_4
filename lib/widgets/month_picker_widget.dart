import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_1_17_4/utils/date_utils.dart';
import 'package:flutter_calendar_1_17_4/widgets/day_picker_widget.dart';

class MonthPickerWidget extends StatefulWidget {
  const MonthPickerWidget({
    @required this.currentDate,
    @required this.firstDate,
    @required this.lastDate,
    @required this.onChanged,
    @required this.onDisplayedMonthChanged,
    this.selectedDate,
    this.selectableDayPredicate,
    this.datePickerMode = DatePickerMode.day,
    Key key,
  });

  final DateTime currentDate;

  final DateTime firstDate;

  final DateTime lastDate;

  final DateTime selectedDate;

  final ValueChanged<DateTime> onChanged;

  final ValueChanged<DateTime> onDisplayedMonthChanged;

  final SelectableDayPredicate selectableDayPredicate;

  final DatePickerMode datePickerMode;

  @override
  State<MonthPickerWidget> createState() => _MonthPickerWidgetState();
}

class _MonthPickerWidgetState extends State<MonthPickerWidget> {
  DateTime _currentMonth;
  DateTime _focusedDay;
  DatePickerMode _datePickerMode;

  final GlobalKey _pageViewKey = GlobalKey();

  PageController _pageController;

  void _handleDateSelected(DateTime selectedDate) {
    _focusedDay = selectedDate;
    widget.onChanged(selectedDate);
  }

  void _handleMonthPageChanged(int monthPage) {
    setState(() {
      final DateTime monthDate =
          DateUtils.addMonthsToMonthDate(widget.firstDate, monthPage);

      if (!DateUtils.isSameMonth(_currentMonth, monthDate)) {
        _currentMonth = DateTime(monthDate.year, monthDate.month);
        widget.onDisplayedMonthChanged(_currentMonth);
        if (_focusedDay != null &&
            !DateUtils.isSameMonth(_focusedDay, _currentMonth)) {
          _focusedDay = _focusableDayForMonth(_currentMonth, _focusedDay.day);
        }
      }
    });
  }

  DateTime _focusableDayForMonth(DateTime month, int preferredDay) {
    final int daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);

    if (preferredDay <= daysInMonth) {
      final DateTime newFocus = DateTime(month.year, month.month, preferredDay);
      if (_isSelectable(newFocus)) {
        return newFocus;
      }
    }
    for (int day = 1; day <= daysInMonth; day++) {
      final DateTime newFocus = DateTime(month.year, month.month, day);
      if (_isSelectable(newFocus)) {
        return newFocus;
      }
    }
    return null;
  }

  bool _isSelectable(DateTime date) {
    return widget.selectableDayPredicate == null ||
        widget.selectableDayPredicate.call(date);
  }

  Widget _buildItems(BuildContext context, int index) {
    final DateTime month =
        DateUtils.addMonthsToMonthDate(widget.firstDate, index);
    return DayPickerWidget(
      key: ValueKey<DateTime>(month),
      selectedDate: widget.selectedDate,
      currentDate: widget.currentDate,
      onChanged: _handleDateSelected,
      displayedMonth: month,
    );
  }

  String _getMonthDescription(int month) {
    switch (month) {
      case DateTime.january:
        return 'Janeiro';
      case DateTime.february:
        return 'Fevereiro';
      case DateTime.march:
        return 'Março';
      case DateTime.april:
        return 'Abril';
      case DateTime.may:
        return 'Maio';
      case DateTime.june:
        return 'Junho';
      case DateTime.july:
        return 'Julho';
      case DateTime.august:
        return 'Agosto';
      case DateTime.september:
        return 'Setembro';
      case DateTime.october:
        return 'Outubro';
      case DateTime.november:
        return 'Novembro';
      case DateTime.december:
        return 'Dezembro';
      default:
        return 'Desconhecido';
    }
  }

  void _changeMonth(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.currentDate;
    _datePickerMode = widget.datePickerMode;
    _currentMonth = widget.firstDate;
    _pageController = PageController(
      initialPage: DateUtils.monthDelta(
        widget.firstDate,
        _currentMonth,
      ),
    );

    // Future.delayed(
    //   const Duration(seconds: 2),
    // ).whenComplete(
    //   () {
    //     // monthAndYearToPageList = _monthAndYearToPage();
    //     // final date = monthAndYearToPageList.firstWhere(
    //     //     (element) => element.month == 2 && element.year == 2040);
    //     setState(
    //       () {
    //         // _handleMonthPageChanged(date.page);
    //         _pageController.jumpToPage(
    //           DateUtils.monthDelta(
    //             _currentMonth,
    //             DateTime(2040, 2),
    //           ),
    //         );
    //       },
    //     );
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeaderMonth(),
        IndexedStack(
          index: (_datePickerMode == DatePickerMode.day) ? 0 : 1,
          children: <Widget>[
            _buildModeMonth(),
            _buildModeYear(),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        _buildButton(context),
      ],
    );
  }

  Widget _buildModeMonth() {
    return SizedBox(
      height: 100,
      child: PageView.builder(
        key: _pageViewKey,
        controller: _pageController,
        itemBuilder: _buildItems,
        itemCount: DateUtils.monthDelta(widget.firstDate, widget.lastDate) + 1,
        onPageChanged: _handleMonthPageChanged,
      ),
    );
  }

  Widget _buildModeYear() {
    return SizedBox(
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                child: ListWheelScrollView(
                  itemExtent: 100,
                  children: List.generate(
                    100,
                    (index) {
                      return Text('Item $index');
                      // return ListTile(
                      //   title: Text('Item $index'),
                      // );
                    },
                  ),
                  // useMagnifier: true,
                  // magnification: 1.5,
                  onSelectedItemChanged: (value) {
                    log('$value');
                  },
                  // diameterRatio: 1.5,
                ),
              ),
              Flexible(
                child: ListWheelScrollView(
                  itemExtent: 12,
                  children: List.generate(
                    12,
                    (index) {
                      return Text(_getMonthDescription(index + 1));
                      // return ListTile(
                      //   title: Text('Item $index'),
                      // );
                    },
                  ),
                  useMagnifier: true,
                  magnification: 1.5,
                  onSelectedItemChanged: (value) {
                    log('$value');
                  },
                  // diameterRatio: 1.5,
                ),
              ),
            ],
          ),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.grey),
          )
        ],
      ),
    );
    return SizedBox(
      height: 100,
      child: CupertinoDatePicker(
        initialDateTime: _focusedDay,
        mode: CupertinoDatePickerMode.date,
        onDateTimeChanged: (DateTime newDate) {
          setState(() {
            _focusedDay = newDate;
            _currentMonth = newDate;
          });
        },
      ),
    );
  }

  GestureDetector _buildButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_datePickerMode == DatePickerMode.year) {
          setState(() {
            _datePickerMode = DatePickerMode.day;
          });
          Future<void>.delayed(
            const Duration(
              milliseconds: 500,
            ),
          ).whenComplete(() {
            _pageController.jumpToPage(
              DateUtils.monthDelta(
                widget.firstDate,
                _currentMonth,
              ),
            );
          });
        } else {
          Navigator.of(context).pop(_focusedDay);
        }
      },
      child: Container(
        margin: EdgeInsets.all(16),
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Center(
          child: Text(
            'OK',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderMonth() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          FlatButton(
            onPressed: () {
              setState(() {
                if (_datePickerMode == DatePickerMode.day) {
                  _datePickerMode = DatePickerMode.year;
                } else {
                  _datePickerMode = DatePickerMode.day;
                }
              });
            },
            padding: EdgeInsets.zero,
            child: Row(
              children: <Widget>[
                Text(
                  _getMonthDescription(_currentMonth.month),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  _currentMonth.year.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                )
              ],
            ),
          ),
          const Spacer(),
          Visibility(
            visible: _datePickerMode == DatePickerMode.day,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    final currentPage = _pageController.page.toInt() ?? 0;
                    _changeMonth(currentPage - 1);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final currentPage = _pageController.page.toInt() ?? 0;
                    _changeMonth(currentPage + 1);
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
