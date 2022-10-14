import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:table_calendar/table_calendar.dart';

import '../home/tasks.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  /// Try to avoid "late" initialization or the calendar will look trippy
  /// I tried to fill in below variables with some defaults
  static DateTime? _selectedDay;
  bool _daySelected = false;
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month; //setting a default

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _daySelected = true;
    });
  }

  void _onFormatChanged(CalendarFormat format) {
    setState(() {
      _calendarFormat = format;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white54,
        child: Column(children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(1970, 1, 1),
            lastDay: DateTime.utc(2199, 12, 31),
            headerVisible: true,
            // weekNumbersVisible: true,
            shouldFillViewport: false,

            /** Adding interactivity */
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,

            /** Included for the ability to change calendar format
         * This is activated by the button on the calendar title
         */
            calendarFormat: _calendarFormat,
            onFormatChanged: _onFormatChanged,

            /** This is to prevent losing the focus of the main day
         * For now I can only see this being helpful in hot reload
         */
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },

            /** Customizing UI */
            calendarStyle: const CalendarStyle(
              outsideDaysVisible: false,
              cellMargin: EdgeInsets.all(0),
              todayDecoration: BoxDecoration(color: Colors.lightBlueAccent, shape: BoxShape.circle),
              todayTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              markerDecoration: BoxDecoration(color: Colors.orange, shape: BoxShape.rectangle),
              selectedDecoration: BoxDecoration(color: Colors.orange, shape: BoxShape.rectangle),
              selectedTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            rowHeight: 50,
          ),
          Expanded(
              child:
                  _daySelected ? TaskList(date: _selectedDay!) : Container()),
        ]));
  }
}
