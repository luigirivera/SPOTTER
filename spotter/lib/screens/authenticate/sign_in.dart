import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple,
        appBar: AppBar(
            backgroundColor: Colors.orange,
            title: const Text("Test sign in"),
        ),
        body: Container(
            child: ElevatedButton(
              child: const Text('Sign in Anon'),
              onPressed: () async {

              },
            )
        )
    );
  }
}
