import 'package:flutter/material.dart';
import '../settings/settings.dart';
import '../calendar/calendar.dart';
import 'taskScreen.dart';
import '../study_session/studySession.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _barIndexSelected = 0;

  void _onBarTap(int index) {
    setState(() {
      _barIndexSelected = index;
    });
  }

  final _screens = [
    const TaskScreen(),
    const Calendar(),
    const StudySession(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade200,
      //
      //Adding background image to the appbar
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/stars.png'),
                fit: BoxFit.fill,
              )),
        ),
        //
        //Adding settings for the drawer
        //will select the drawer in the scaffold
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
        //
        //Changing icon theme
        iconTheme: const IconThemeData(color: Colors.orange),
      ),
      drawer: const SettingsDrawer(),
      body: _screens[_barIndexSelected],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
          BottomNavigationBarItem(
              icon: Icon(Icons.edit_calendar), label: 'Calendar'),
          BottomNavigationBarItem(
              icon: Icon(Icons.book), label: 'Study Session'),
        ],
        onTap: _onBarTap,
        currentIndex: _barIndexSelected,
      ),
    );
  }
}
