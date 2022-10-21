import 'package:flutter/material.dart';
import '../../main.dart';
import '../../models/task_model.dart';

Future _addTask(
    String description, String group, DateTime date, bool completed) async {
  Task newTask = Task(
    taskDescription: description,
    completed: completed,
  );
  TaskGroup taskGroup = objectbox.getTaskGroup(group)!;

  if (!objectbox.ifTaskDateExists(date)) {
    objectbox.addTaskDate(date);
  }

  TaskDate taskDate = objectbox.getTaskDate(date);

  //Data relations
  newTask.taskDate.target = taskDate;
  newTask.taskGroup.target = taskGroup;

  taskDate.taskGroups.add(taskGroup);
  taskDate.taskGroups.applyToDb();

  await objectbox.addTask(newTask);
}

class AddTaskAndGroup extends StatefulWidget {
  final DateTime date;

  const AddTaskAndGroup({Key? key, required this.date}) : super(key: key);

  @override
  State<AddTaskAndGroup> createState() => _AddTaskAndGroupState();
}

class _AddTaskAndGroupState extends State<AddTaskAndGroup> {
  final _formKey = GlobalKey<FormState>();

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
  String description = '';
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
                        description = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),

                  ///Task group drop down form
                  DropdownButtonFormField<String>(
                      menuMaxHeight: 300,
                      value:
                          objectbox.getTaskGroupList().elementAt(0).taskGroup,
                      items: objectbox.getTaskGroupList().map((value) {
                        return DropdownMenuItem<String>(
                            value: value.taskGroup,
                            child: Text(value.taskGroup));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          group = value.toString();
                        });
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
            await _addTask(description, group, date, completed)
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
  late String description;
  late String group;
  late DateTime date;
  final completed = false;

  @override
  void initState() {
    super.initState();
    description = widget.task.taskDescription;
    group = widget.task.taskGroup.target!.taskGroup;
    date = widget.date;
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
                    initialValue: description,
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
                        description = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),

                  ///Task group drop down form
                  DropdownButtonFormField<String>(
                      menuMaxHeight: 300,
                      value: group,
                      items: objectbox.getTaskGroupList().map((value) {
                        return DropdownMenuItem<String>(
                            value: value.taskGroup,
                            child: Text(value.taskGroup));
                      }).toList(),
                      onChanged: (value) {
                        group = value.toString();
                      }),
                  const SizedBox(height: 20),

                  ///The date picker section
                  Text('${date.month} / ${date.day}/ ${date.year}'),
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
          child: const Text('Cancel Editing'),
        ),
        TextButton(
          onPressed: () async {
            await objectbox.deleteTask(widget.task);
            await _addTask(description, group, date, completed)
                .then((value) => Navigator.of(context).pop());
          },
          child: const Text('Finish'),
        )
      ],
    );
  }
}

class EditTaskGroup extends StatefulWidget {
  const EditTaskGroup({Key? key}) : super(key: key);

  @override
  State<EditTaskGroup> createState() => _EditTaskGroupState();
}

class _EditTaskGroupState extends State<EditTaskGroup> {
  String? newGroup;
  bool groupExists = false;
  List<bool> selectedGroups = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    List<TaskGroup> taskGroupList = objectbox.getTaskGroupList();

    int total = taskGroupList.length;

    if (selectedGroups.isEmpty) {
      selectedGroups = List.filled(total, false, growable: true);
    } else if (selectedGroups.length != taskGroupList.length) {
      selectedGroups.add(false);
    }

    return AlertDialog(
      content: SizedBox(
          height: 400,
          width: 400,
          child: Column(children: [
            ///Field to add a task
            SizedBox(
                height: 50,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Expanded(
                      child: TextFormField(
                    decoration: InputDecoration(
                        enabledBorder: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 2.5),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue.shade500, width: 3),
                        ),
                        hintText: "New group here:",
                        filled: true,
                        fillColor: Colors.grey.shade100),
                    onChanged: (value) {
                      newGroup = value;
                    },
                  )),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.orange),
                    onPressed: () async {
                      if (objectbox.getTaskGroup(newGroup!) == null) {
                        await objectbox.addTaskGroup(newGroup!).then((value) {
                          setState(() {});
                        });
                        groupExists = false;
                      } else {
                        groupExists = true;
                      }
                    },
                  ),

                  ///Button for deleting tasks
                  IconButton(
                    onPressed: () async {
                      await objectbox
                          .deleteSelectedTaskGroups(
                              taskGroupList, selectedGroups)
                          .whenComplete(() {
                        setState(() {
                          selectedGroups = List.empty(growable: true);
                        });
                      });
                    },
                    icon: const Icon(Icons.delete_outline, color: Colors.grey),
                    tooltip: 'Delete selected',
                  ),
                ])),

            groupExists
                ? const SizedBox(
                    height: 20,
                    child: Text('Groups exists already!',
                        style: TextStyle(color: Colors.red)))
                : const SizedBox(height: 20, child: Text('')),

            Expanded(
                child: ListView.builder(
                    physics: const ScrollPhysics(),
                    itemCount: total * 2,
                    itemBuilder: (BuildContext context, int index) {
                      if (index.isOdd) {
                        return const Divider();
                      }
                      int i = index ~/ 2;
                      return Row(mainAxisSize: MainAxisSize.min, children: [
                        taskGroupList[i].taskGroup != 'General'
                            ? selectedGroups[i]
                                ? IconButton(
                                    icon: const Icon(Icons.check_box_outlined,
                                        color: Colors.green),
                                    onPressed: () {
                                      setState(() {
                                        selectedGroups[i] = false;
                                      });
                                    },
                                  )
                                : IconButton(
                                    icon: const Icon(Icons.crop_square_outlined,
                                        color: Colors.blue),
                                    onPressed: () {
                                      setState(() {
                                        selectedGroups[i] = true;
                                      });
                                    })
                            : const SizedBox(width: 48),
                        Container(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            height: 50,
                            width: 170,
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                                child: Text(taskGroupList[i].taskGroup,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))))
                      ]);
                    }))
          ])),
    );
  }
}
