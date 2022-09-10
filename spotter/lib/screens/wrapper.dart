import 'package:flutter/material.dart';
import 'authenticate/authenticate.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //return either authenticate or home page
    return const Authenticate();
  }
}
