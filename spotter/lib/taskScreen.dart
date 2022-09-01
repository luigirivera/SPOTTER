import 'package:flutter/material.dart';
import 'tasks.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  static void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    void rebuild() {
      rebuildAllChildren(context);
    }

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
        child: Center(
            child: TextButton(
          child: const Text('test'),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TaskPage(
                          outerContext: context,
                        )));
          },
        )),
      ),
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

class TaskPage extends StatelessWidget {
  final BuildContext outerContext;
  const TaskPage({Key? key, required this.outerContext}) : super(key: key);

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
                _TaskScreenState otherScreen = _TaskScreenState();
                otherScreen.build(outerContext);
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: const TaskList(),
    );
  }
}
