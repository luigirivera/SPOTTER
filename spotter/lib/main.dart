import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

int length = 0;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Spotter'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class RemindersList extends StatefulWidget {
  const RemindersList({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<RemindersList> createState() => _RemindersListState();
}

class _RemindersListState extends State<RemindersList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text('Item $index'), //label per entry
          onTap: (() {
            //action trigger
            print('Tapped item $index');
          }),
        );
      },
    );
  }
}

class Reminders extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RemindersState();
}

class _RemindersState extends State<Reminders> {
  void _temp() {
    setState(() {
      length = length + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reminders"),
      ),
      body: const Center(
        child: RemindersList(
          title: "Reminders",
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _temp,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Calendar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
      ),
      body: TableCalendar(
        firstDay: DateTime.utc(1970, 1, 1),
        lastDay: DateTime.utc(2099, 12, 31),
        focusedDay: DateTime.now(),
      ),
    );
  }
}

class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int page = 0;

  final _pages = [
    Reminders(),
    Calendar(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      // appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(widget.title),
      // ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Reminders"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: "Calendar"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
        currentIndex: page,
        onTap: (int index) {
          setState(() {
            page = index;
          });
        },
      ),
      body: _pages[page],
    );
  }
}
