import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  /// Try to avoid "late" initialization or the calendar will look trippy
  /// I tried to fill in below variables with some defaults
  static DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks; //setting a default

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: _focusedDay,
      firstDay: DateTime.utc(1970, 1, 1),
      lastDay: DateTime.utc(2199, 12, 31),
      headerVisible: true,
      weekNumbersVisible: true,
      shouldFillViewport: false,

      /** Adding interactivity */
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
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

      /** This is to prevent losing the focus of the main day
       * For now I can only see this being helpful in hot reload
       */
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },

      /** Customizing UI */
      calendarStyle: const CalendarStyle(
        outsideDaysVisible: false,
      ),
    );
  }
}
