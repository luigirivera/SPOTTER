import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/task_model.dart';
import '../../services/database.dart';
import 'tasks.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  ///Default value for initialData
  List<Task> defaultTaskList = List.filled(1, Task(taskDescription: 'taskDescription', taskGroup: 0, completed: false));

  @override
  Widget build(BuildContext context) {
    debugPrint('\n\nThis is the length: ${defaultTaskList.length}\n\n');
    return StreamProvider<List<Task>>.value(
        initialData: defaultTaskList,
        value: DatabaseService().tasks,
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
    ]));
  }
}