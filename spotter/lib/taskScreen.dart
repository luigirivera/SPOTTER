import 'package:flutter/material.dart';
import 'tasks.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  int test = 0;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      //
      //
      //The first section; Task board.
      const TaskBoard(),
      //
      //
      //The second section; Textbox.
      Container(
        height: 100,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/filler.png'), fit: BoxFit.fill)),
      ),
      //
      //
      //The third section; Mascot
      Expanded(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/space.png'), fit: BoxFit.fill),
          ),
        ),
      ),
    ]);
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
      body: TaskList(
        popped: true,
      ),
    );
  }
}
