import 'package:flutter/material.dart';
import '../../services/auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue.shade200,
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text("Test sign up"),
        ),
        body: SafeArea(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Text("Sign Up", style: TextStyle(fontSize: 30)),
              SizedBox(height: 20),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue.shade800),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "Email",
                          filled: true,
                          fillColor: Colors.grey.shade200))),
              SizedBox(height: 10),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue.shade800),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "Password",
                          filled: true,
                          fillColor: Colors.grey.shade200))),
              SizedBox(height: 10),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue.shade800),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(vertical: 15)),
                      ),
                      onPressed: () async {
                        dynamic result = await _auth.anonSignIn();
                        if (result == null) {
                          print('error signing in');
                        } else {
                          print('signed in \n$result\n');
                          print(result.uid);
                        }
                      },
                      child: Center(
                        child: Text("Sign up",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                      ))),
            ],
          )),
        ));
  }
}
