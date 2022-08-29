import 'package:flutter/material.dart';
import 'settings.dart';
import 'tasks.dart';

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
        //The first section of the homepage; Task board.
        const TaskBoard(),
        //
        //
        //The second section of the homepage; Textbox.
        Expanded(
          child: Container(),
        ),
        //
        //
        //The third section of the homepage; Mascot.
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.blue,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 30, top: 15),
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.all(0)),
                                onPressed: () {
                                  print("Tasks Pressed");
                                },
                                child: Text(
                                  'Tasks',
                                  style: Theme.of(context).textTheme.headline6,
                                ))),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 60, top: 15),
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.all(0)),
                                onPressed: () {
                                  print("Calendar Pressed");
                                },
                                child: Text(
                                  'Calendar',
                                  style: Theme.of(context).textTheme.headline6,
                                ))),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 60, top: 15),
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.all(0)),
                                onPressed: () {
                                  print("Study Session Pressed");
                                },
                                child: Text(
                                  'Study Session',
                                  style: Theme.of(context).textTheme.headline6,
                                ))),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 30, top: 15),
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.all(0)),
                                onPressed: () {
                                  print("Market Pressed");
                                },
                                child: Text(
                                  'Market',
                                  style: Theme.of(context).textTheme.headline6,
                                ))),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
