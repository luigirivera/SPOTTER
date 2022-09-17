import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spotter/models/user_model.dart';
import '../../services/auth.dart';
import '../loading/loading.dart';
import 'sign_up.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool hidePassword = true;
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
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
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.white))
                ]),
            body: SafeArea(
              child: Center(
                  child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          const Text("Spotter", style: TextStyle(fontSize: 30)),
                          const SizedBox(height: 20),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue.shade800),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintText: "Email",
                                    filled: true,
                                    fillColor: Colors.grey.shade200),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter an email';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() => email = value);
                                },
                              )),
                          const SizedBox(height: 10),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: TextFormField(
                                obscureText: hidePassword,
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue.shade800),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintText: "Password",
                                    filled: true,
                                    fillColor: Colors.grey.shade200,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        hidePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.orange,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (hidePassword) {
                                            hidePassword = false;
                                          } else {
                                            hidePassword = true;
                                          }
                                        });
                                      },
                                    )),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a password';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() => password = value);
                                },
                              )),
                          const SizedBox(height: 10),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.blue.shade800),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(
                                            vertical: 15)),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        loading = true;
                                      });
                                      dynamic result =
                                          await _auth.signInEP(email, password);
                                      if (result is! SpotterUser) {
                                        setState(() {
                                          // error = result;
                                          Fluttertoast.showToast(
                                              msg: result,
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 5,
                                              backgroundColor: Colors.black,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                          loading = false;
                                        });
                                      }
                                    }
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
                                            builder: (context) =>
                                                const SignUp()));
                                  },
                                  child: Text("Sign up",
                                      style: TextStyle(
                                          color: Colors.blue.shade800,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)))
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(error,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14)),
                        ],
                      ))),
            ));
  }
}
