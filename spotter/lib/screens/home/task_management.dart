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
  DateTime date = DateTime.now();
  final List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  String? newGroup;
  String description = '';
  String group = "General";
  bool completed = false;

  @override
  Widget build(BuildContext context) {
    date = widget.date;
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
                      newGroup = value;
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
                  if (newGroup != null) {
                    await objectbox.addTaskGroup(newGroup!);
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
                              description = value;
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
                                date = temp;
                              }
                              setState(() {});
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
                onPressed: () {
                  Task newTask = Task(
                    taskDescription: description,
                    completed: completed,
                  );

                  TaskGroup taskGroup = objectbox.getTaskGroup(group);
                  TaskDate taskDate = objectbox.getTaskDate(date);

                  ///Data relations
                  newTask.taskDate.target = taskDate;
                  newTask.taskGroup.target = taskGroup;
                  taskGroup.tasks.add(newTask);
                  taskDate.tasks.add(newTask);
                  taskDate.taskGroups.add(taskGroup);

                  taskDate.taskGroups.applyToDb();
                  taskDate.tasks.applyToDb();
                  taskGroup.tasks.applyToDb();

                  objectbox.addTask(newTask);

                  Navigator.of(context).pop();
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
  bool descriptionChanged = false;

  String newGroup = '';
  bool groupChanged = false;

  DateTime newDate = DateTime.now();
  bool dateChanged = false;

  @override
  Widget build(BuildContext context) {
    newDate = widget.date;
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
                    initialValue: widget.task.taskDescription,
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
                        descriptionChanged = true;
                      });
                    },
                  ),
                  const SizedBox(height: 10),

                  ///Task group drop down form
                  DropdownButtonFormField<String>(
                      menuMaxHeight: 300,
                      value: widget.task.taskGroup.target!.taskGroup,
                      items: objectbox
                          .getTaskGroupListWithoutAddOption()
                          .map((taskGroupValue) {
                        return DropdownMenuItem<String>(
                            value: taskGroupValue.taskGroup,
                            child: Text(taskGroupValue.taskGroup));
                      }).toList(),
                      onChanged: (value) {
                        newGroup = value.toString();
                        groupChanged = true;
                      }),
                  const SizedBox(height: 20),

                  ///The date picker section
                  Text('${newDate.month} / ${newDate.day} / ${newDate.year}'),
                  Text(weekdays[newDate.weekday - 1]),
                  TextButton(
                      onPressed: () async {
                        DateTime? temp = await showDatePicker(
                            context: context,
                            initialDate: widget.date,
                            confirmText: 'Okay',
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100));
                        if (temp != null) {
                          newDate = temp;
                        }
                        setState(() {});
                        dateChanged = true;
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
            Task newTask = widget.task;
            TaskDate newTaskDate = objectbox.getTaskDate(newDate);
            TaskDate tempTaskDate = widget.task.taskDate.target!;
            TaskGroup newTaskGroup = objectbox.getTaskGroup(newGroup);
            TaskGroup tempTaskGroup = widget.task.taskGroup.target!;

            if (descriptionChanged) {
              newTask.taskDescription = newDescription;
            }
            if (groupChanged) {
              tempTaskDate.tasks.add(newTask);
              tempTaskDate.tasks.remove(widget.task);
              tempTaskDate.tasks.applyToDb();

              //for some reason the list, let alone the objectbox, can't
              //find the 'General' task group object, maybe it is because it's
              // the data relation messing it up or because
              //it wasn't created through objectbox instance
              // , but instead upon user register.
              //I can only do it this way.
              List<TaskGroup> taskGroupListCopy =
                  tempTaskDate.taskGroups.toList();
              tempTaskDate.taskGroups.clear();
              tempTaskDate.taskGroups.applyToDb();
              taskGroupListCopy.add(newTaskGroup);
              for (var taskGrp in taskGroupListCopy) {
                if (tempTaskGroup.taskGroup != taskGrp.taskGroup) {
                  tempTaskDate.taskGroups.add(taskGrp);
                  tempTaskDate.taskGroups.applyToDb();
                }
              }

              newTask.taskGroup.target!.tasks.remove(newTask);
              newTask.taskGroup.target!.tasks.applyToDb();

              newTask.taskGroup.target = newTaskGroup;
              newTaskGroup.tasks.add(newTask);
              newTaskGroup.tasks.applyToDb();
            }
            if (dateChanged) {
              tempTaskDate.tasks.remove(widget.task);
              tempTaskDate.taskGroups.remove(widget.task.taskGroup.target);

              newTask.taskDate.target = newTaskDate;
              newTaskDate.tasks.add(newTask);
              newTaskDate.taskGroups.add(newTaskGroup);
              newTaskDate.taskGroups.remove(widget.task.taskGroup.target!);

              newTaskDate.taskGroups.applyToDb();
              newTaskDate.tasks.applyToDb();
            }
            if (tempTaskDate.tasks.isEmpty) {
              objectbox.deleteTaskDate(tempTaskDate);
            }

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
