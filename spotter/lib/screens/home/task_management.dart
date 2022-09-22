import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotter/services/task_database.dart';

import '../../models/task_model.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();
  final TaskDatabaseService taskData = TaskDatabaseService();
  late String taskDescription;
  String? taskGroup;

  @override
  Widget build(BuildContext context) {
    late String taskDescription;
    late String taskGroup;
    bool completed;

    return AlertDialog(
      content: Form(
        key: _formKey,
          child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue.shade800),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "What is your new task?",
                filled: true,
                fillColor: Colors.grey.shade200),
            /** Help in validating formats */
            validator: (value) => value!.isEmpty ? 'Enter a task here' : null,
            onChanged: (value) {
              setState(() => taskDescription = value);
            },
          ),
          DropdownButtonFormField(
              items:
                  taskData.getTaskGroups().map((taskGroup) {
                return DropdownMenuItem<String>(
                    child: Text(taskGroup.taskGroup));
              }).toList(),
              onChanged: (value) =>
                  setState(() => taskGroup = value as String)),
        ],
      )),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            taskData.addTask(taskGroup, taskDescription, false);
            Navigator.of(context).pop();
          },
          child: const Text('Okay'),
        )
      ],
    );
  }
}

class EditTask extends StatefulWidget {
  const EditTask({Key? key}) : super(key: key);

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Task"),
      ),
      body: Column(
        children: [
          //Name box
          //Description box
          //Group
          //Date picker
          //Time picker
          //Priority picker
          //Save button
        ],
      ),
    );
  }
}
