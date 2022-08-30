import 'package:flutter/material.dart';

class TaskBoard extends StatefulWidget {
  const TaskBoard({Key? key}) : super(key: key);

  @override
  State<TaskBoard> createState() => _TaskBoardState();
}

class _TaskBoardState extends State<TaskBoard> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
            border: Border.all(color: Colors.blue, width: 5),
            borderRadius: const BorderRadius.all(Radius.circular(40)),
          ),
          child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: 20,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: const Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                  trailing: const Icon(Icons.check_box_outline_blank_rounded),
                  title: Text("Task _$index"),
                );
              }),
        ),
      ),
    );
  }
}
