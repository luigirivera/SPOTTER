import 'package:flutter/material.dart';
import '../../main.dart';
import '../../models/task_model.dart';

class AddTaskAndGroup extends StatefulWidget {
  final DateTime date;

  const AddTaskAndGroup({Key? key, required this.date}) : super(key: key);

  @override
  State<AddTaskAndGroup> createState() => _AddTaskAndGroupState();
}

class _AddTaskAndGroupState extends State<AddTaskAndGroup> {
  final _formKey = GlobalKey<FormState>();
  bool isAddingGroup = false;

  ///This date is subjected to change if user picked another
  ///The change will be reflected on the screen
  late DateTime date;
  final List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  String? newTaskGroupName;
  String newDescription = '';
  String group = "General";
  bool completed = false;

  @override
  void initState() {
    super.initState();
    date = widget.date;
  }

  @override
  Widget build(BuildContext context) {
    ///Using a StatefulBuilder to wrap the AlertDialogs to ensure they rebuild as desired
    ///showDialog doesn't work here due to different return types

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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a group here';
                      } else if (objectbox
                          .ifTaskGroupExistsInObjectBox(value)) {
                        return 'Group name already exists!';
                      }
                      return '';
                    },
                    onChanged: (value) {
                      newTaskGroupName = value;
                    },
                  )),
            ),
            actions: <Widget>[
              ///Default skipping button
              TextButton(
                onPressed: () {
                  setState(() {
                    isAddingGroup = false;
                  });
                },
                child: const Text('Cancel'),
              ),

              ///Add new task group to the database
              ///Skip if no inputs are present
              TextButton(
                onPressed: () async {
                  if (newTaskGroupName != null) {
                    await objectbox.addTaskGroup(newTaskGroupName!);
                    isAddingGroup = false;
                  }
                  setState(() {});
                },
                child: const Text('Okay'),
              ),
            ],
          )

        ///Alert dialogue for adding new tasks
        : AlertDialog(
            content: SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.5,
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        ///Task description input text box form field
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
                            setState(() {
                              newDescription = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),

                        ///Task group drop down form
                        DropdownButtonFormField<String>(
                            menuMaxHeight: 300,
                            value: objectbox
                                .getTaskGroupList()
                                .elementAt(1)
                                .taskGroup,
                            items: objectbox
                                .getTaskGroupList()
                                .map((taskGroupValue) {
                              return DropdownMenuItem<String>(
                                  value: taskGroupValue.taskGroup,
                                  child: Text(taskGroupValue.taskGroup));
                            }).toList(),
                            onChanged: (value) {
                              if (value.toString() == '+ Add a New Group') {
                                setState(() {
                                  isAddingGroup = true;
                                });
                              } else {
                                setState(() {
                                  group = value.toString();
                                });
                              }
                            }),
                        const SizedBox(height: 20),

                        ///The date picker section
                        Text('${date.month} / ${date.day} / ${date.year}'),
                        Text(weekdays[date.weekday - 1]),
                        TextButton(
                            onPressed: () async {
                              DateTime? temp = await showDatePicker(
                                  context: context,
                                  initialDate: date,
                                  confirmText: 'Okay',
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100));
                              if (temp != null) {
                                setState(() {
                                  date = temp;
                                });
                              }
                            },
                            child: const Text('Pick a Date'))
                      ],
                    ))),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Task newTask = Task(
                    taskDescription: newDescription,
                    completed: completed,
                  );

                  TaskGroup taskGroup = objectbox.getTaskGroup(group);
                  TaskDate taskDate = objectbox.getTaskDate(date);

                  ///Data relations
                  newTask.taskDate.target = taskDate;
                  newTask.taskGroup.target = taskGroup;
                  taskDate.taskGroups.add(taskGroup);

                  taskDate.taskGroups.applyToDb();

                  await objectbox
                      .addTask(newTask)
                      .then((value) => Navigator.of(context).pop());
                },
                child: const Text('Okay'),
              )
            ],
          );
  }
}

class EditTask extends StatefulWidget {
  final Task task;
  final DateTime date;

  const EditTask({Key? key, required this.task, required this.date})
      : super(key: key);

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  final _formKey = GlobalKey<FormState>();
  String newDescription = '';
  String newGroup = '';
  DateTime newDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    newDescription = widget.task.taskDescription;
    newGroup = widget.task.taskGroup.target!.taskGroup;
    newDate = widget.task.taskDate.target!.date;
  }

  bool groupChanged = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.5,
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  ///Task description input text box form field
                  TextFormField(
                    initialValue: newDescription,
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
                      setState(() {
                        newDescription = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),

                  ///Task group drop down form
                  DropdownButtonFormField<String>(
                      menuMaxHeight: 300,
                      value: newGroup,
                      items: objectbox
                          .getTaskGroupListWithoutAddOption()
                          .map((taskGroupValue) {
                        return DropdownMenuItem<String>(
                            value: taskGroupValue.taskGroup,
                            child: Text(taskGroupValue.taskGroup));
                      }).toList(),
                      onChanged: (value) {
                        newGroup = value.toString();
                      }),
                  const SizedBox(height: 20),

                  ///The date picker section
                  Text('${newDate.month} / ${newDate.day}/ ${newDate.year}'),
                  TextButton(
                      onPressed: () async {
                        DateTime? temp = await showDatePicker(
                            context: context,
                            initialDate: newDate,
                            confirmText: 'Okay',
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100));
                        if (temp != null) {
                          setState(() {
                            newDate = temp;
                          });
                        }
                      },
                      child: const Text('Pick a Date'))
                ],
              ))),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel Editing'),
        ),
        TextButton(
          onPressed: () async {
            await objectbox.deleteTask(widget.task);

            Task newTask =
                Task(taskDescription: newDescription, completed: false);
            TaskGroup newTaskGroup = objectbox.getTaskGroup(newGroup);
            newTask.taskGroup.target = newTaskGroup;
            newTask.taskDate.target = objectbox.getTaskDate(newDate);
            newTask.taskDate.target!.taskGroups.add(newTaskGroup);
            newTask.taskDate.target!.taskGroups.applyToDb();

            await objectbox
                .addTask(newTask)
                .then((value) => Navigator.of(context).pop());
          },
          child: const Text('Finish'),
        )
      ],
    );
  }
}
