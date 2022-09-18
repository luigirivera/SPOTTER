import 'package:flutter/material.dart';

class EditTask extends StatefulWidget {
  const EditTask({Key? key}) : super(key: key);

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Task"),
      ),
      body: const Column(
        children: [
          //Name box
          //Description box
          //Group
          //Date picker
          //Time picker
          //Priority picker
          //Save button
        ],
      ),
    );
  }
}
