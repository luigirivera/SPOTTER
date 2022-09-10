import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotter/models/user.dart';
import 'package:spotter/screens/wrapper.dart';
import 'package:spotter/services/auth.dart';
import 'settings.dart';
import 'calendar.dart';
import 'scrollHighlightRemove.dart';
import 'taskScreen.dart';
import 'studySession.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /** Adding the ? in the type specification to be able to set initialData to null */
    return StreamProvider<SpotterUser?>.value(
        initialData: null,
        value: AuthService().user,
        child: MaterialApp(
          title: 'Spotter',
          theme: ThemeData(primarySwatch: Colors.red),
          home: const Wrapper(),
          builder: (BuildContext context, child) {
            return ScrollConfiguration(
              behavior: MyBehavior(),
              child: child!,
            );
          },
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
