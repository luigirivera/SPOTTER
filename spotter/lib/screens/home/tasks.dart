import 'package:flutter/material.dart';
import 'package:spotter/screens/home/task_management.dart';
import '../../main.dart';
import '../../models/task_model.dart';

class TaskBoard extends StatelessWidget {
  const TaskBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
          border: Border.all(color: Colors.blue, width: 5),
          borderRadius: const BorderRadius.all(Radius.circular(40)),
        ),
        child: const TaskList(),
      ),
    );
  }
}

class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    List<Task> taskList = objectbox.getTaskListByDate(DateTime.now());
    return Column(children: [
      SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <IconButton>[
            IconButton(
              icon: const Icon(
                Icons.add_circle,
                color: Colors.orange,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return const AddTask();
                    }).then((value) {
                  setState(() {});
                });
              },
              tooltip: 'Add new tasks',
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TaskPopOutPage(date: DateTime.now()),
                    )).then((value) {
                  setState(() {});
                });
              },
              icon: const Icon(Icons.output),
              tooltip: 'View in a pop out',
            ),
          ],
        ),
      ),
      Expanded(
          child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: taskList.length * 2,
              itemBuilder: (BuildContext context, int index) {
                if (index.isOdd) return const Divider();
                final i = index ~/ 2;
                final check = taskList[i].completed;

                /** Putting tasks onto the task board */
                return ListTile(
                  title: Text(
                      'Task: ${taskList[i].taskDescription} Group: ${taskList[i].taskGroup}'),
                  leading:
                      const Icon(Icons.arrow_forward_ios, color: Colors.orange),
                  trailing: IconButton(
                    icon: Icon(
                      check
                          ? Icons.check_box_outlined
                          : Icons.check_box_outline_blank_rounded,
                      color: check ? Colors.orange.shade900 : Colors.black,
                      semanticLabel: check ? 'Completed' : 'Incomplete',
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        if (check) {
                          taskList[i].completed = false;

                          ///Overwrite
                          objectbox.addTask(taskList[i]);
                        } else {
                          taskList[i].completed = true;
                          objectbox.addTask(taskList[i]);
                        }
                      });
                    },
                  ),
                );
              })),
    ]);
  }
}

class TaskPopOutPage extends StatefulWidget {
  final DateTime date;

  const TaskPopOutPage({Key? key, required this.date}) : super(key: key);

  @override
  State<TaskPopOutPage> createState() => _TaskPopOutPageState();
}

class _TaskPopOutPageState extends State<TaskPopOutPage> {
  @override
  Widget build(BuildContext context) {
    List<TaskGroup> taskGroup = objectbox.getTaskGroupByDate(widget.date);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
            image: AssetImage('assets/sea_appbar.png'),
            fit: BoxFit.fill,
          ))),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.orange,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              itemCount: taskGroup.length,
              itemBuilder: (BuildContext context, int index) {
                //This is for the '+ add group', it's not supposed to be in the list
                if (index == 0) {
                  return const Divider();
                }
                if (index.isEven) return const Divider();
                final i = index ~/ 2;
                List<Task> taskList = objectbox.getTaskListByGroupAndDate(
                    widget.date, taskGroup[i]);
                return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListView.builder(
                      itemCount: taskList.length * 2,
                      itemBuilder: (BuildContext context, int innerIndex) {
                        if(innerIndex == 0) {
                          return ListTile(
                            title: Text(taskGroup[i].taskGroup),
                            tileColor: Colors.yellow,
                          );
                        }

                        if (innerIndex.isOdd) return const Divider();
                        final j = index ~/ 2;
                        bool check = taskList[j].completed;

                        return ListTile(
                          title: Text(
                              'Task: ${taskList[j].taskDescription}'),
                          leading: const Icon(Icons.arrow_forward_ios,
                              color: Colors.orange),
                          trailing: IconButton(
                            icon: Icon(
                              check
                                  ? Icons.check_box_outlined
                                  : Icons.check_box_outline_blank_rounded,
                              color:
                                  check ? Colors.orange.shade900 : Colors.black,
                              semanticLabel: check ? 'Completed' : 'Incomplete',
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                if (check) {
                                  taskList[j].completed = false;

                                  ///Update task to the list
                                  objectbox.addTask(taskList[j]);
                                } else {
                                  taskList[j].completed = true;

                                  ///Update task to the list
                                  objectbox.addTask(taskList[j]);
                                }
                              });
                            },
                          ),
                        );
                      },
                    ));
              },
            ))
        //^ do group length
        );
  }
}
