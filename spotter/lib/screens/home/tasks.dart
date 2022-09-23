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
    List<Task> taskList = objectbox.getTaskList();
    return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: taskList.length * 2 + 1,
              itemBuilder: (BuildContext context, int index) {
                /** Creating a list of IconButtons,
                 * then add the default plus button in to create a pop-up for adding new tasks.
                 * Able to add more buttons if desired in the future
                 */
                if (index == 0) {
                  List<IconButton> buttons = List.empty(growable: true);

                  buttons.add(IconButton(
                    icon: const Icon(
                      Icons.add_circle,
                      color: Colors.orange,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {
                            return AddTask(
                              objectbox: objectbox,
                            );
                          }).then((value) {
                        setState(() {});
                      });
                    },
                    tooltip: 'Add new tasks',
                  ));

                  /** If page pop triggered,
                   * then add the page pop button to the list
                   */
                  if (!widget.popped) {
                    buttons.add(IconButton(
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
                    ));
                  }

                  /** Adding the buttons in the list to the first row */
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: buttons.map((button) {
                      return Container(
                        child: (button),
                      );
                    }).toList(),
                  );
                }

                if (index.isOdd) return const Divider();
                final i = (index ~/ 2) - 1;
                final check = taskList[i].completed;

                /** Putting tasks onto the task board */
                return ListTile(
                  title: Text(
                      '${taskList[i].taskDescription} Group ID: ${taskList[i].taskGroup}'),
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
                          //set data to false
                        } else {
                          //set data to true
                        }
                      });
                    },
                  ),
                );
              });
  }
}

class TaskPopOutPage extends StatelessWidget {
  const TaskPopOutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
          image: AssetImage('assets/stars.png'),
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
      body: const TaskList(
        popped: true,
      ),
    );
  }
}
