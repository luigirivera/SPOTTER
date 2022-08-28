import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotter',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      endDrawer: const SettingsDrawer(),
      body: Column(children: [
        //
        //
        //The first section of the homepage; Task board.
        Expanded(
          child: Container(
            color: Colors.orange,
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    border: Border.all(color: Colors.blue, width: 5),
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                  ),
                  child: ListView(
                    children: const [
                      Text("Task 1"),
                      Text("Task 2"),
                      Text("Task 3"),
                      Text("Task 4"),
                    ],
                  )),
            ),
          ),
        ),
        //
        //
        //The second section of the homepage; Textbox.
        Expanded(
          child: Container(
            color: Colors.yellow,
          ),
        ),
        //
        //
        //The third section of the homepage; Mascot.
        Expanded(
          child: Container(
            color: Colors.pink,
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
