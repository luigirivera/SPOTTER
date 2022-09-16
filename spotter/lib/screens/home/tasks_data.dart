import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/task_model.dart';

class TaskData extends StatefulWidget {
  const TaskData({Key? key}) : super(key: key);

  @override
  State<TaskData> createState() => _TaskDataState();
}

class _TaskDataState extends State<TaskData> {
  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<List<Task>>(context);

    for (var task in tasks) {
      debugPrint(task.icon.toString());
      debugPrint(task.taskDescription);
      debugPrint(task.taskGroup.toString());
    }

    return Container();
  }
}
