import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import 'package:spotter/screens/authenticate/sign_in.dart';
import '../home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SpotterUser>(context);

    //return either authenticate or home page
    if (user.uid == null) {
      return const SignIn();
    } else {
      debugPrint('Le debug print: ${user.uid}');
      return const Home(title: 'Spotter');
    }
  }
}
