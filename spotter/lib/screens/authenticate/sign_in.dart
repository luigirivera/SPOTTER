import 'package:flutter/material.dart';
import '../../services/auth.dart';
import 'sign_up.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue.shade200,
        appBar: AppBar(
            backgroundColor: Colors.orange,
            title: const Text("Test sign in"),
            actions: <Widget>[
              TextButton.icon(
                  onPressed: () async {
                    dynamic result = await _auth.anonSignIn();
                    if (result == null) {
                      debugPrint('error signing in');
                    } else {
                      debugPrint('signed in \n$result\n');
                      debugPrint(result.uid);
                    }
                  },
                  icon: const Icon(Icons.person),
                  label: const Text("Guest Login"),
                  style: TextButton.styleFrom(foregroundColor: Colors.white))
            ]),
        body: SafeArea(
          child: Center(
              child: Form(
                  child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Text("Spotter", style: TextStyle(fontSize: 30)),
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
                        fillColor: Colors.grey.shade200),
                    onChanged: (value) {
                      setState(() => email = value);
                    },
                  )),
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
                        fillColor: Colors.grey.shade200),
                    onChanged: (value) {
                      setState(() => password = value);
                    },
                  )),
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
                        debugPrint(email);
                        debugPrint(password);
                      },
                      child: const Center(
                        child: Text("Sign in",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                      ))),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUp()));
                      },
                      child: Text("Sign up",
                          style: TextStyle(
                              color: Colors.blue.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)))
                ],
              )
            ],
          ))),
        ));
  }
}
