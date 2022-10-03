import 'package:flutter/material.dart';
import '../../main.dart';
import '../../models/task_model.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

///This method handles adding task and task group
///The task group addition is performed in here for rebuilding and variable book keeping convenience
///Switching between the two modes by a boolean
///This method also handles the data-relationship between task and date
class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();
  bool isAddingGroup = false;

  ///This date is subjected to change if user picked another
  ///The change will be reflected on the screen
  DateTime date = DateTime.now();
  List<String> weekdays = [
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
  bool groupAddSuccess = true;

  @override
  Widget build(BuildContext context) {
    return isAddingGroup

        ///Second alert dialogue for inputting new task group
        ///It's second because it's supposed show up after the other one does
        ? AlertDialog(
            content:
              SizedBox(
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
                        if(value!.isEmpty){
                          return 'Enter a group here';
                        }else if(objectbox.ifTaskGroupExistsInObjectBox(value)){
                          return 'Group name already exists!';
                        }
                        return '';
                      },
                      onChanged: (value) {
                        newGroup = value;
                      },
                    )),
              ),

            ///Skip when there's no input in the text box when 'Okay' is clicked
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
              TextButton(
                onPressed: () {
                  if (newGroup != null) {
                      setState(() {
                        isAddingGroup = false;
                      });
                  }
                },
                child: const Text('Okay'),
              ),
            ],
          )

        ///First alert dialogue for adding new tasks
        : AlertDialog(
            content: SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.5,
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
                        value: objectbox.getTaskGroupList().elementAt(1).taskGroup,
                        items: objectbox.getTaskGroupList().map((taskGroup) {
                          return DropdownMenuItem<String>(
                              value: taskGroup.taskGroup,
                              child: Text(taskGroup.taskGroup));
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
                )),
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
