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
              const SizedBox(height: 10),
              const Text("Sign Up", style: TextStyle(fontSize: 30)),
              const SizedBox(height: 20),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue.shade800),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "Email",
                          filled: true,
                          fillColor: Colors.grey.shade200))),
              const SizedBox(height: 10),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue.shade800),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "Password",
                          filled: true,
                          fillColor: Colors.grey.shade200))),
              const SizedBox(height: 10),
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
                          debugPrint('error signing in');
                        } else {
                          debugPrint('signed in \n$result\n');
                          debugPrint(result.uid);
                        }
                      },
                      child: const Center(
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
