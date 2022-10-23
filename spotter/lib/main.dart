import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotter/models/user_model.dart';
import 'package:spotter/screens/authenticate/wrapper.dart';
import 'package:spotter/services/auth.dart';
import 'package:spotter/services/connectivity.dart';
import 'objectbox.dart';
import 'scrollHighlightRemove.dart';
import 'package:firebase_core/firebase_core.dart';

late final ObjectBox objectbox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ConnectivityService();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  objectbox = await ObjectBox.open();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  ///Default SpotterUser value for initialData
  final SpotterUser defaultSpotterUser = SpotterUser(uid: null);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<SpotterUser>.value(
        initialData: defaultSpotterUser,
        value: AuthService().user,
        child: MaterialApp(
          title: 'Spotter',
          theme: ThemeData(primarySwatch: Colors.red),
          home: const Wrapper(),
          builder: (BuildContext context, child) {
            return ScrollConfiguration(
              behavior: MyBehavior(),
              child: child!,
            );
          },
        ));
  }
}
