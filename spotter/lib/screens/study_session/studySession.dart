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

  Timer? timer;
  bool isTimerRunning = false;

  int treePhase = 1;
  int completedTrees = 0;

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

      treePhase = 1;
      completedTrees = 0;
    });
  }

  void start() {
    timer = Timer.periodic(const Duration(microseconds: 1), (timer) {
      setState(() {
        milliseconds++;

        switch (minutes) {
          //new tree phase every 5 minutes
          case 5:
            treePhase = 2;
            break;
          case 10:
            treePhase = 3;
            break;
          case 15:
            treePhase = 4;
            break;
          case 20:
            treePhase = 5;
            break;
          case 25:
            treePhase = 6;
            break;
          case 30:
            treePhase = 7;
            break;
          case 35:
            treePhase = 8;
            break;
          case 40:
            treePhase = 9;
            break;
          case 45:
            treePhase = 10;
            break;
          case 50:
            treePhase = 11;
            break;
          case 55:
            treePhase = 12;
            break;
        }

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

          treePhase = 1;
          completedTrees++;
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
    return Padding(
      padding: EdgeInsets.all(25),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("$hoursString:$minutesString:$secondsString",
                style: const TextStyle(fontSize: 50, color: Colors.black)),
            SizedBox(
              height: 100,
            ),
            Expanded(
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                      "Tree Phase: $treePhase\nTrees Completed: $completedTrees",
                      style:
                          const TextStyle(fontSize: 20, color: Colors.black))),
            ),
            Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.black,
                            //rounded corners
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                    color: Colors.black, width: 2))),
                        onPressed: isTimerRunning ? stop : start,
                        child: Text(isTimerRunning ? "Stop" : "Start"),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.black,
                            //rounded corners
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                    color: Colors.black, width: 2))),
                        onPressed: reset,
                        child: Text("Reset"),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
