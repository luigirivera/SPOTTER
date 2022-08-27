import 'package:flutter/material.dart';

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

class Reminders extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RemindersState();
}

class _RemindersState extends State<Reminders> {
  List<bool> itemValues = List.generate(length, (index) => false);

  void _temp() {
    setState(() {
      itemValues.add(false);
      length = length + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reminders"),
      ),
      body: ListView.builder(
        itemCount: length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: UniqueKey(),
            onDismissed: ((direction) {
              setState(() {});
            }),
            child: CheckboxListTile(
              title: Text('Item $index'), //label per entry
              value: itemValues[index],
              controlAffinity: ListTileControlAffinity.leading,
              secondary: PopupMenuButton(
                itemBuilder: ((context) => [
                      PopupMenuItem(
                        onTap: () {},
                        child: Text("Edit"),
                        value: 1,
                      )
                    ]),
                icon: Icon(Icons.menu),
              ),
              onChanged: ((val) {
                setState(() {
                  itemValues[index] = val!;
                });
              }),
            ),
          );
        },
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
