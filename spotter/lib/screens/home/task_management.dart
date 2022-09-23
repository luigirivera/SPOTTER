import 'package:flutter/material.dart';
import '../../models/task_model.dart';
import '../../objectbox.dart';

class AddTask extends StatefulWidget {
  final ObjectBox objectbox;
  const AddTask({Key? key, required this.objectbox}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String taskDescription = '';
    String taskGroup = "General";
    bool completed = false;

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
                validator: (value) =>
                    value!.isEmpty ? 'Enter a task here' : null,
                onChanged: (value) {
                  taskDescription = value;
                },
              ),
              DropdownButtonFormField(
                  items: widget.objectbox.getTaskGroups().map((taskGroup) {
                    return DropdownMenuItem<String>(
                        child: Text(taskGroup.taskGroup));
                  }).toList(),
                  onChanged: (value) {
                    taskGroup = value.toString();
                  }),
            ],
          )),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            widget.objectbox.addTask(Task(taskDescription: taskDescription, taskGroup: taskGroup, completed: completed));
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
        children: const [
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
