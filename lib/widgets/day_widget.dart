import 'package:flutter/material.dart';
import 'package:flutter_calendar_1_17_4/widgets/enum/day_status.dart';

class DayWidget extends StatelessWidget {
  const DayWidget({
    @required this.day,
    @required this.dayStatus,
    @required this.onChanged,
    Key key,
  });

  final DateTime day;
  final DayStatus dayStatus;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final textStyle = _getTextStyle(dayStatus);

    final backgroundColor = _getBackgroundColor(dayStatus);

    final dayToBuild = day.day;

    return GestureDetector(
      onTap: () {
        if (dayStatus != DayStatus.isDisabled) {
          onChanged(day);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            dayToBuild.toString(),
            style: textStyle,
          ),
        ),
      ),
    );
  }

  TextStyle _getTextStyle(DayStatus dayStatus) {
    switch (dayStatus) {
      case DayStatus.isDisabled:
        return const TextStyle(color: Colors.grey);
      case DayStatus.isSelectedDay:
        return const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        );

      default:
        return const TextStyle(color: Colors.black);
    }
  }

  Color _getBackgroundColor(DayStatus dayStatus) {
    switch (dayStatus) {
      case DayStatus.isSelectedDay:
        return Colors.orange;

      default:
        return null;
    }
  }
}
