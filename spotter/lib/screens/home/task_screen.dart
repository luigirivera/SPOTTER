import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'tasks.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/beach.png'), fit: BoxFit.fill)),
        child: Column(children: [
          //
          //
          //The first section; Task board.
          const TaskBoard(),
          //
          //
          //The second section; Text box.
          Container(
            height: 100,
          ),
          //
          //
          //The third section; Mascot
          // const Expanded(
          //
          //   child: RiveAnimation.asset('assets/spotter_home.riv'),
          // ),
        ]));
  }
}
