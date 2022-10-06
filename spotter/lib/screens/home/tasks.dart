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
  bool deletionMade = false;

  @override
  Widget build(BuildContext context) {
    List<Task> taskList = objectbox.getTaskListByDate(widget.date);
    return Column(children: [
      SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <IconButton>[
            ///A button to add a new task
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
                      return const AddTaskAndGroup();
                    }).then((value) {
                  setState(() {});
                });
              },
              tooltip: 'Add new tasks',
            ),

            ///Button for pop out view of the task board
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskPopOutPage(date: widget.date),
                    )).then((value) {
                  setState(() {});
                });
              },
              icon: const Icon(Icons.output),
              tooltip: 'View in a pop out',
            ),

            ///Button for deleting tasks
            IconButton(
              onPressed: () async {
                deletionMade =
                    await objectbox.deleteSelectedTasks(taskList, widget.date);
                setState(() {});
              },
              icon: const Icon(Icons.delete),
              tooltip: 'Delete selected',
            ),
          ],
        ),
      ),

      ///The actual task list itself
      Expanded(
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
                  leading:
                      const Icon(Icons.arrow_forward_ios, color: Colors.orange),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                      icon: Icon(
                        check
                            ? Icons.check_box_outlined
                            : Icons.check_box_outline_blank_rounded,
                        color: check ? Colors.orange.shade900 : Colors.black,
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

  @override
  Widget build(BuildContext context) {
    List<TaskGroup> taskGroup = objectbox.getTaskGroupsByDate(widget.date);
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
              children: <IconButton>[
                ///A button to add a new task
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
                          return const AddTaskAndGroup();
                        }).then((value) {
                      setState(() {});
                    });
                  },
                  tooltip: 'Add new tasks',
                ),

                ///Button for deleting tasks
                IconButton(
                  onPressed: () async {
                    deletionMade = await objectbox.deleteSelectedTasks(
                        objectbox.getTaskListByDate(widget.date), widget.date);
                    setState(() {});
                  },
                  icon: const Icon(Icons.delete),
                  tooltip: 'Delete selected',
                ),
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
                  widget.date, taskGroup[i]);
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
