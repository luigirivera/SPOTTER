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
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
                border: Border.all(color: Colors.blue, width: 5),
                borderRadius: const BorderRadius.all(Radius.circular(40)),
              ),
              child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: 20,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: const Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      trailing:
                          const Icon(Icons.check_box_outline_blank_rounded),
                      title: Text("Task _$index"),
                    );
                  }),
            ),
          ),
        ),
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
