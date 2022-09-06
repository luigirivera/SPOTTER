//Classes: TaskItem, TaskGroup, TaskData, TaskBoard, TaskList
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spotter/taskScreen.dart';

class TaskGroup {
  late String groupTitle;
  late Color groupColor;
  TaskGroup(groupTitle, groupColor);
}

class TaskItem {
  var g = TaskGroup('SomeTitle', Colors.amber);
  late TaskGroup itemGroup = g;
  Icon itemIcon = const Icon(Icons.abc);
  String itemTask = 'SomeItem';
  bool completed = false;
}

class TaskData {
  static int amount = 1;
  static late List<TaskItem> taskList;
}

class TaskBoard extends StatelessWidget {
  const TaskBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/filler.png'), fit: BoxFit.fill)),
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
  final bool popped;
  const TaskList({Key? key, this.popped = false}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: TaskData.amount + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0 && !widget.popped) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TaskPopOutPage(),
                        )).then((value) {
                      setState(() {});
                    });
                  },
                  icon: const Icon(Icons.output),
                  tooltip: 'View in a pop out',
                )
              ],
            );
          }
          if (index.isOdd) return const Divider();
          final i = index ~/ 2;
          final check = TaskData.taskList[i].completed;

          return ListTile(
            title: Text("Task _$i"),
            leading: const Icon(
              Icons.star,
              color: Colors.yellow,
            ),
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
                    TaskData.taskList[i].completed = false;
                  } else {
                    TaskData.taskList[i].completed = true;
                  }
                });
              },
            ),
          );
        });
  }
}
