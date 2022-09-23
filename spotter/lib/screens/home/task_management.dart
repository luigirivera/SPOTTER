import 'package:flutter/material.dart';
import '../../main.dart';
import '../../models/task_model.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();
  bool isAddingGroup = false;

  @override
  Widget build(BuildContext context) {
    String? newTaskGroup;
    String taskDescription = '';
    String taskGroup = "General";
    bool completed = false;

    return isAddingGroup
        ? AlertDialog(
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.2,
              child: Form(
                  key: _formKey,
                  child: TextFormField(
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue.shade800),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "What is your new group?",
                        filled: true,
                        fillColor: Colors.grey.shade200),
                    /** Help in validating formats */
                    validator: (value) =>
                        value!.isEmpty ? 'Enter a group here' : null,
                    onChanged: (value) {
                      taskGroup = value;
                    },
                  )),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  if (newTaskGroup != null) {
                    objectbox.addTaskGroup(newTaskGroup);
                  }
                  isAddingGroup = false;
                  setState(() {});
                },
                child: const Text('Okay'),
              ),
              TextButton(
                onPressed: () {
                  isAddingGroup = false;
                  setState(() {});
                },
                child: const Text('Cancel'),
              )
            ],
          )
        : AlertDialog(
            content: SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.5,
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue.shade800),
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
                            items: objectbox.getTaskGroups().map((taskGroup) {
                              return DropdownMenuItem<String>(
                                  value: taskGroup.taskGroup,
                                  child: Text(taskGroup.taskGroup));
                            }).toList(),
                            onChanged: (value) {
                              if (value.toString() == '+ Add a New Group') {
                                isAddingGroup = true;
                                setState(() {});
                              } else {
                                taskGroup = value.toString();
                              }
                            }),
                      ],
                    ))),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  objectbox.addTask(Task(
                    taskDescription: taskDescription,
                    taskGroup: taskGroup,
                    completed: completed,
                    date: DateTime.now(),
                  ));
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
