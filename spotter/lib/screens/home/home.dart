import 'package:flutter/material.dart';
import '../../models/task_model.dart';
import '../../objectbox.dart';
import '../statistics/statistics.dart';
import '../settings/settings.dart';
import '../calendar/calendar.dart';
import 'task_screen.dart';
import '../study_session/studySession.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _barIndexSelected = 0;
late final ObjectBox objectbox;
  void _onBarTap(int index) {
    setState(() {
      _barIndexSelected = index;
    });
  }
  void func() async {
    objectbox = await ObjectBox.open();
    List<Task> tempList = objectbox.getTaskList();
    debugPrint('\n\nThis is debugPrint: ${tempList.length}\n\n');
  }
  final _screens = [
    const TaskScreen(),
    const Calendar(),
    const StudySession(),
    const StatisticsScreen(),
  ];

  ///Default value for initialData
  List<Task> defaultTaskList = List.filled(
      1,
      Task(
          taskDescription: 'taskDescription',
          taskGroup: 'General',
          completed: false));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade200,

      ///Adding background image to the appbar
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/stars.png'),
                fit: BoxFit.fill,
              )),
        ),

        ///Adding settings for the drawer
        ///will select the drawer in the scaffold
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
                func();
              },
            );
          },
        ),

        iconTheme: const IconThemeData(color: Colors.orange),
      ),

      ///Bottom screen selection row
      drawer: const SettingsDrawer(),
      body: _screens[_barIndexSelected],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
          BottomNavigationBarItem(
              icon: Icon(Icons.edit_calendar), label: 'Calendar'),
          BottomNavigationBarItem(
              icon: Icon(Icons.book), label: 'Study Session'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Statistic'),
        ],
        onTap: _onBarTap,
        currentIndex: _barIndexSelected,
      ),
    );
  }
}
