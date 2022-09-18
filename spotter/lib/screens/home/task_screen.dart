import 'package:flutter/material.dart';
import 'tasks.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      //
      //
      //The first section; Task board.
      const TaskBoard(),
      //
      //
      //The second section; Text box.
      Container(
        height: 100,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/filler.png'), fit: BoxFit.fill)),
      ),
      //
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
    ]);
  }
}