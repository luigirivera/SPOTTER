import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import '../../models/session_model.dart';
import '../../main.dart';

class StudySession extends StatefulWidget {
  const StudySession({Key? key}) : super(key: key);

  @override
  State<StudySession> createState() => _StudySessionState();
}

class _StudySessionState extends State<StudySession> {
  StudyTheme theme = objectbox.getTheme();
  final String themeFolder = 'assets/themes/';
  String selectedTheme = '1_trees/';
  String fileName = 'trees';

  int milliseconds = 0;
  int seconds = 0;
  int minutes = 0;
  int hours = 0;

  String secondsString = "00";
  String minutesString = "00";
  String hoursString = "00";

  Timer? timer;
  bool isTimerRunning = false;
  bool newTree = false;

  int phase = 1;
  int completed = 0;

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

      phase = 1;
      completed = 0;
    });
  }

  void updateTimer() {
    setState(() {
      milliseconds++;

      switch (minutes % 5) {
        //new tree phase every minute
        case 1:
          phase = 2;
          break;
        case 2:
          phase = 3;
          break;
        case 3:
          phase = 4;
          break;
        case 4:
          phase = 5;
          newTree = true;
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

      if (minutes % 5 == 0 && newTree) {
        phase = 1;
        newTree = !newTree;
        completed++;
      }
      if (minutes == 60) {
        minutes = 0;
        hours++;
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
  }

  void start() {
    if (Platform.isAndroid) {
      timer = Timer.periodic(const Duration(microseconds: 1), (timer) {
        updateTimer();
      });
    } else {
      timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
        updateTimer();
      });
    }
    setState(() {
      isTimerRunning = true;
    });
  }

  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    initTheme();
    super.initState();
  }

  void initTheme() async {
    print(theme.index);
    var assetsFile =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(assetsFile);

    List<String> thumbnails = manifestMap.keys
        .where((String key) =>
            key.contains('assets/themes/thumbnails/') && key.contains('.png'))
        .toList();

    //grab folder names from file names
    thumbnails = thumbnails.map((e) {
      return e
          .split(RegExp(r'assets/themes/thumbnails/'))[1]
          .split(RegExp(r'\.'))[0];
    }).toList();

    print(thumbnails);

    if (theme.index < 0) {
      selectedTheme = '${thumbnails[0]}/';
    } else {
      selectedTheme = '${thumbnails[theme.index]}/';
    }

    fileName = selectedTheme.split(RegExp(r'_'))[1].split(r'/')[0];

    print(selectedTheme);
    print(fileName);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                // image: AssetImage('assets/beach.png'), fit: BoxFit.fill)
                image: AssetImage(completed <= 6
                    ? '$themeFolder$selectedTheme$fileName-$completed.png'
                    : '$themeFolder$selectedTheme$fileName-6.png'),
                fit: BoxFit.fill)),
        child: Padding(
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
                          "Tree Phase: $phase\nTrees Completed: $completed",
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black))),
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
        ));
  }
}
