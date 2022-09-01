import 'package:flutter/material.dart';
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
  //putting boolean here to test the interactions with the task board
  //can be removed later if actual tasks were implemented

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          Data data = Data();

          if (index.isOdd) return const Divider();

          final check = data.getCompletion(index ~/ 2);

          return ListTile(
            title: Text("Task _$index"),
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
                    data.setCompletion(index ~/ 2, false);
                  } else {
                    data.setCompletion(index ~/ 2, true);
                  }
                });
              },
            ),
          );
        });
  }
}
