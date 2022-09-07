import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  /// try to avoid "late" initialization or the calendar will look trippy
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks; //setting a default

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: DateTime.now(),
      firstDay: DateTime.utc(1970, 1, 1),
      lastDay: DateTime.utc(2199, 12, 31),
      headerVisible: true,
      weekNumbersVisible: true,
      shouldFillViewport: false,

      /** Adding interactivity */
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },

      /** Included for the ability to change calendar format
       * This is activated by the button on the calendar title
       */
      calendarFormat: _calendarFormat,
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },


      // onPageChanged: (focusedDay) {
      //   _focusedDay = focusedDay;
      // },
    );
  }
}
