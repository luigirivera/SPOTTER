import 'package:flutter/material.dart';
import 'package:spotter/screens/home/tasks.dart';
import 'package:spotter/screens/study_session/themes.dart';
import '../statistics/statistics.dart';
import '../settings/settings.dart';
import '../calendar/calendar.dart';
import 'task_screen.dart';
import '../study_session/studySession.dart';
import '../../main.dart';
import '../loading/loading.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _barIndexSelected = 0;
  bool loading = false;

  void _onBarTap(int index) {
    setState(() {
      _barIndexSelected = index;
    });
  }

  final _screens = [
    const TaskScreen(),
    const Calendar(),
    const StudySession(),
    const StatisticsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      onDrawerChanged: (isOpened) {
        if (!isOpened) {
          switch (_barIndexSelected) {
            case 0:
              taskChange = true;
              break;
            case 1:
              calendarChange = true;
              break;
            case 2:
              sessionChange = true;
              break;
            case 3:
              statChange = true;
              break;
          }
        }
      },
      backgroundColor: Colors.blue.shade200,

      ///Adding background image to the appbar
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/sea_appbar.png'),
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
              },
            );
          },
        ),

        iconTheme: const IconThemeData(color: Colors.orange),

        actions: _barIndexSelected == 2
            ? <Widget>[
                TextButton.icon(
                    icon: const Icon(Icons.image),
                    label: const Text('Themes'),
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      final result = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Themes()));

                      print(result);
                      setState(() {
                        loading = result;
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.orange,
                    )),
              ]
            : null,
      ),

      ///Bottom screen selection row
      drawer: const SettingsDrawer(),
      body: loading ? const Loading() : _screens[_barIndexSelected],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
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
