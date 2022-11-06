import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spotter/screens/home/task_management.dart';
import '../../main.dart';
import '../../models/task_model.dart';
import '../../services/connectivity.dart';

bool taskChange = false;

class TaskBoard extends StatelessWidget {
  const TaskBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          border: Border.all(color: Colors.blue[100]!, width: 3),
        ),
        child: TaskList(date: DateTime.now()),
      ),
    );
  }
}

class TaskList extends StatefulWidget {
  final DateTime date;

  const TaskList({Key? key, required this.date}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<Task> taskList = List.empty(growable: true);
  late Timer t;
  late Timer t2;

  void refresh() {
    t2 = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && taskChange) {
        setState(() {});
        taskChange = false;
      }
    });
  }

  @override
  void dispose() {
    t.cancel();
    t2.cancel();
    super.dispose();
  }

  @override
  void initState() {
    if (mounted) {
      t = Timer(Duration(seconds: 2), () {
        setState(() {
          if (objectbox.ifTaskDateExists(widget.date)) {
            taskList = objectbox.getTaskListByDate(widget.date);
          }
        });
      });
    }

    refresh();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (objectbox.ifTaskDateExists(widget.date)) {
      taskList = objectbox.getTaskListByDate(widget.date);
    }

    return Column(children: [
      SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ///A button to add a new task
            IconButton(
              icon: const Icon(
                Icons.add_circle,
                color: Colors.orange,
              ),
              onPressed: () async {
                debugPrint(await ConnectivityService().status);
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return AddTaskAndGroup(date: widget.date);
                    }).then((value) {
                  setState(() {});
                });
              },
              tooltip: 'Add new tasks',
            ),

            ///Button for deleting tasks
            IconButton(
              onPressed: () async {
                await objectbox.deleteSelectedTasks(taskList, widget.date);
                setState(() {});
              },
              icon: const Icon(Icons.delete_outline, color: Colors.grey),
              tooltip: 'Delete selected',
            ),

            ///Editing groups
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orange)),
              child: const Text('Groups',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return const EditTaskGroup();
                    }).then((value) {
                  setState(() {});
                });
              },
            ),

            const SizedBox(width: 10),

            ///Button for pop out view of the task board
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.redAccent)),
              child: const Text(
                'View By Groups',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskPopOutPage(date: widget.date),
                    )).then((value) {
                  setState(() {});
                });
              },
            ),
          ],
        ),
      ),

      ///The actual task list itself
      taskList.isEmpty
          ? Expanded(
              child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/nothing2.png'))),
            ))
          : Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: taskList.length * 2,
                  itemBuilder: (BuildContext context, int index) {
                    if (index.isOdd) return const Divider();
                    final i = index ~/ 2;
                    final check = taskList[i].completed;

                    return ListTile(
                      title: Text(
                        taskList[i].taskDescription,
                        style: check
                            ? const TextStyle(
                                fontSize: 15,
                                decoration: TextDecoration.lineThrough)
                            : const TextStyle(fontSize: 15),
                      ),
                      leading: const Icon(Icons.square, color: Colors.orange),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(
                          icon: Icon(
                            check
                                ? Icons.check_box_outlined
                                : Icons.check_box_outline_blank_rounded,
                            color:
                                check ? Colors.orange.shade900 : Colors.black,
                            semanticLabel: check ? 'Completed' : 'Incomplete',
                            size: 30,
                          ),

                          ///Update the completion status of the task
                          ///Put setState after onPressed; setState can't be async
                          onPressed: () async {
                            if (check) {
                              taskList[i].completed = false;

                              ///Overwrite
                              await objectbox.addTask(taskList[i]);
                            } else {
                              taskList[i].completed = true;
                              await objectbox.addTask(taskList[i]);
                            }
                            setState(() {});
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return EditTask(
                                      task: taskList[i], date: widget.date);
                                }).then((value) {
                              setState(() {});
                            });
                          },
                        )
                      ]),
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
  bool deletionMade = false;
  late Timer t;
  List<TaskGroup> taskGroup = List.empty(growable: true);

  @override
  void dispose() {
    t.cancel();
    super.dispose();
  }

  @override
  void initState() {
    t = Timer(Duration(seconds: 2), () {
      setState(() {
        if (objectbox.ifTaskDateExists(widget.date)) {
          taskGroup = objectbox.getTaskGroupsByDate(widget.date);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (objectbox.ifTaskDateExists(widget.date)) {
      taskGroup = objectbox.getTaskGroupsByDate(widget.date);
    }

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

        ///This SizedBox houses a nested ListView structure.
        ///Outer ListView are the groups
        ///Inner ListView are the tasks of the groups
        ///Only showing tasks of a given day (passed as a variable to this class)
        body: Column(children: [
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ///A button to add a new task
                IconButton(
                  icon: const Icon(
                    Icons.add_circle,
                    color: Colors.orange,
                  ),
                  onPressed: () async {
                    debugPrint(await ConnectivityService().status);
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          return AddTaskAndGroup(date: widget.date);
                        }).then((value) {
                      setState(() {});
                    });
                  },
                  tooltip: 'Add new tasks',
                ),

                ///Button for deleting tasks
                IconButton(
                  onPressed: () async {
                    await objectbox.deleteSelectedTasks(
                        objectbox.getTaskListByDate(widget.date), widget.date);
                    setState(() {});
                  },
                  icon: const Icon(Icons.delete_outline, color: Colors.grey),
                  tooltip: 'Delete selected',
                ),

                ///Editing groups
                TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.orange)),
                  child: const Text('Groups',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          return const EditTaskGroup();
                        }).then((value) {
                      setState(() {});
                    });
                  },
                ),

                const SizedBox(width: 10),

                ///Button for pop out view of the task board
                // TextButton(
                //   style: ButtonStyle(
                //       backgroundColor:
                //           MaterialStateProperty.all(Colors.redAccent)),
                //   child: const Text(
                //     'View By Groups',
                //     style: TextStyle(
                //         color: Colors.white, fontWeight: FontWeight.bold),
                //   ),
                //   onPressed: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) =>
                //               TaskPopOutPage(date: widget.date),
                //         )).then((value) {
                //       setState(() {});
                //     });
                //   },
                // ),
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: taskGroup.length * 2,
            itemBuilder: (BuildContext context, int index) {
              if (index.isOdd) return const Divider();
              final i = index ~/ 2;
              List<Task> taskList = objectbox.getTaskListByGroupAndDate(
                  objectbox.getTaskDate(widget.date), taskGroup[i]);
              return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListView.builder(
                    ///The shrinkwrap and physics are necessary to avoid ListView nesting error
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: taskList.length * 2 + 1,
                    itemBuilder: (BuildContext context, int innerIndex) {
                      if (innerIndex == 0) {
                        return ListTile(
                          title: Text(taskGroup[i].taskGroup),
                          tileColor: Colors.yellow,
                        );
                      }
                      if (innerIndex.isEven) return const Divider();
                      final j = (innerIndex - 1) ~/ 2;
                      bool check = taskList[j].completed;

                      return ListTile(
                        title: Text(taskList[j].taskDescription,
                            style: check
                                ? const TextStyle(
                                    fontSize: 15,
                                    decoration: TextDecoration.lineThrough)
                                : const TextStyle(fontSize: 15)),
                        leading: const Icon(Icons.arrow_forward_ios,
                            color: Colors.orange),
                        trailing:
                            Row(mainAxisSize: MainAxisSize.min, children: [
                          IconButton(
                            icon: Icon(
                              check
                                  ? Icons.check_box_outlined
                                  : Icons.check_box_outline_blank_rounded,
                              color:
                                  check ? Colors.orange.shade900 : Colors.black,
                              semanticLabel: check ? 'Completed' : 'Incomplete',
                              size: 30,
                            ),
                            onPressed: () async {
                              if (check) {
                                taskList[j].completed = false;

                                ///Update task to the list
                                await objectbox.addTask(taskList[j]);
                              } else {
                                taskList[j].completed = true;

                                ///Update task to the list
                                await objectbox.addTask(taskList[j]);
                              }
                              setState(() {});
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return EditTask(
                                        task: taskList[j], date: widget.date);
                                  }).then((value) {
                                setState(() {});
                              });
                            },
                          )
                        ]),
                      );
                    },
                  ));
            },
          ))
        ]));
  }
}
