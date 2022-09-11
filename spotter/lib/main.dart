import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotter/models/user.dart';
import 'package:spotter/screens/wrapper.dart';
import 'package:spotter/services/auth.dart';
import 'screens/settings/settings.dart';
import 'screens/calendar/calendar.dart';
import 'scrollHighlightRemove.dart';
import 'screens/home/taskScreen.dart';
import 'screens/study_session/studySession.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /** Adding the ? in the type specification to be able to set initialData to null */
    return StreamProvider<SpotterUser?>.value(
        initialData: null,
        value: AuthService().user,
        child: MaterialApp(
          title: 'Spotter',
          theme: ThemeData(primarySwatch: Colors.red),
          builder: (BuildContext context, child) {
            return ScrollConfiguration(
              behavior: MyBehavior(),
              child: child!,
            );
          },
          home: const Wrapper(),
        ));
  }
}

