import 'package:flutter/material.dart';

class StudySession extends StatefulWidget {
  const StudySession({Key? key}) : super(key: key);

  @override
  State<StudySession> createState() => _StudySessionState();
}

class _StudySessionState extends State<StudySession> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text(
            'Study Session',
            style: TextStyle(fontSize: 30),
          ),
        ],
      ),
    );
  }
}
