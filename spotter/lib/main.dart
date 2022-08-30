import 'package:flutter/material.dart';
import 'settings.dart';
import 'tasks.dart';
import 'navigationBar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotter',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        iconTheme: const IconThemeData(color: Colors.orange),
      ),
      drawer: const SettingsDrawer(),
      body: Column(children: [
        //
        //
        //The first section; Task board.
        const TaskBoard(),
        //
        //
        //The second section; Textbox.
        Container(
          height: 100,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/filler.png'), fit: BoxFit.fill)),
        ),
        //
        //The third section; Mascot
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/space.png'), fit: BoxFit.fill),
            ),
          ),
        ),
      ]),
      bottomNavigationBar: const NavBar(),
    );
  }
}
