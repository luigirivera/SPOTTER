import 'dart:async';

import 'package:flutter/material.dart';

class StudySession extends StatefulWidget {
  const StudySession({Key? key}) : super(key: key);

  @override
  State<StudySession> createState() => _StudySessionState();
}

class _StudySessionState extends State<StudySession> {
  int milliseconds = 0;
  int seconds = 0;
  int minutes = 0;
  int hours = 0;

  String secondsString = "00";
  String minutesString = "00";
  String hoursString = "00";
  String milliSecondsString = "00";

  Timer? timer;
  bool isTimerRunning = false;
  void stop() {
    timer!.cancel();

    setState(() {
      isTimerRunning = false;
    });
  }

  void reset() {
    timer!.cancel();

    setState(() {
      isTimerRunning = false;
      seconds = 0;
      minutes = 0;
      hours = 0;
      milliseconds = 0;
      secondsString = "00";
      minutesString = "00";
      hoursString = "00";
      milliSecondsString = "00";
    });
  }

  void start() {
    timer = Timer.periodic(const Duration(microseconds: 1), (timer) {
      setState(() {
        milliseconds++;
        if (milliseconds == 1000) {
          milliseconds = 0;
          seconds++;
        }
        if (seconds == 60) {
          seconds = 0;
          minutes++;
        }
        if (minutes == 60) {
          minutes = 0;
          hours++;
        }
        if (milliseconds < 10) {
          milliSecondsString = "00" + milliseconds.toString();
        } else if (milliseconds < 100) {
          milliSecondsString = "0" + milliseconds.toString();
        } else {
          milliSecondsString = milliseconds.toString();
        }
        if (seconds < 10) {
          secondsString = "0" + seconds.toString();
        } else {
          secondsString = seconds.toString();
        }
        if (minutes < 10) {
          minutesString = "0" + minutes.toString();
        } else {
          minutesString = minutes.toString();
        }
        if (hours < 10) {
          hoursString = "0" + hours.toString();
        } else {
          hoursString = hours.toString();
        }
      });
    });
    setState(() {
      isTimerRunning = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("$hoursString:$minutesString:$secondsString:$milliSecondsString",
              style: const TextStyle(fontSize: 50)),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: isTimerRunning ? stop : start,
                child: Text(isTimerRunning ? "Stop" : "Start"),
              ),
              SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: reset,
                child: Text("Reset"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
