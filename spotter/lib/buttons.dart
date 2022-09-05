//Classes/Buttons : TaskFormButton, TaskPagePopUpButton
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'taskScreen.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({super.key});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class TaskPagePopUpButton extends StatefulWidget {
  const TaskPagePopUpButton({super.key});

  @override
  State<TaskPagePopUpButton> createState() => _TaskPagePopUpButtonState();
}

class _TaskPagePopUpButtonState extends State<TaskPagePopUpButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
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
    );
  }
}
