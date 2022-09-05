import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spotter/taskScreen.dart';
import 'test_data.dart';

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
        child: TaskList(
          popped: false,
        ),
      ),
    );
  }
}

class TaskList extends StatefulWidget {
  late bool popped;
  TaskList({Key? key, required this.popped}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0 && !widget.popped) {
            return Center(
                child: Row(
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
                ),
              ],
            ));
          }
          if (index.isOdd) return const Divider();
          final i = index ~/ 2;
          final check = Data.completed[i];

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
                    Data.completed[i] = false;
                  } else {
                    Data.completed[i] = true;
                  }
                });
              },
            ),
          );
        });
  }
}
