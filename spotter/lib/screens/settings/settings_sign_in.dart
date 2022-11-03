import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spotter/models/user_model.dart';
import 'package:spotter/services/connectivity.dart';
import 'package:spotter/services/firebase.dart';
import '../../services/auth.dart';
import '../loading/loading.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool signup = false;
  bool hidePassword = true;
  String email = '';
  String password = '';
  String error = '';

  final ConnectivityService _connection = ConnectivityService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue.shade200,
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text("Sign in"),
        ),
        body: loading
            ? const Loading()
            : SafeArea(
                child: Center(
                    child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            const Text("Spotter",
                                style: TextStyle(fontSize: 30)),
                            const SizedBox(height: 5),
                            const Text("Tasks Companion",
                                style: TextStyle(fontSize: 15)),
                            const SizedBox(height: 20),

                            ///Email text box
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue.shade800,
                                            width: 2.5),
                                        borderRadius: BorderRadius.circular(15),
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

                            ///Password text box
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: TextFormField(
                                  obscureText: hidePassword,
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue.shade800,
                                            width: 2.5),
                                        borderRadius: BorderRadius.circular(15),
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

                            ///Sign in button section
                            if (!signup) ...[
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 80.0),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          backgroundColor: Colors.transparent,
                                          foregroundColor: Colors.blue.shade800,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: BorderSide(
                                                color: Colors.blue.shade800,
                                                width: 3),
                                          )),
                                      onPressed: () async {
                                        if (await _connection
                                            .ifConnectedToInternet()) {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              loading = true;
                                            });
                                            User? anonUser =
                                                _auth.currentAuthUser();
                                            dynamic result = await _auth
                                                .signInEP(email, password);
                                            if (result is! SpotterUser) {
                                              setState(() {
                                                // error = result;
                                                Fluttertoast.showToast(
                                                    msg: result,
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 5,
                                                    backgroundColor:
                                                        Colors.black,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                                loading = false;
                                              });
                                            } else {
                                              // await _auth
                                              //     .deleteGivenUser(anonUser!);
                                              checkIfHasData();
                                            }

                                            Navigator.of(context).pop();
                                          }
                                        }
                                      },
                                      child: const Center(
                                        child: Text("Sign in",
                                            style: TextStyle(
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
                                        setState(() {
                                          signup = true;
                                        });
                                      },
                                      child: Text("Sign up",
                                          style: TextStyle(
                                              color: Colors.blue.shade800,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)))
                                ],
                              ),
                            ] else ...[
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 80.0),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          backgroundColor: Colors.transparent,
                                          foregroundColor: Colors.blue.shade800,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: BorderSide(
                                                color: Colors.blue.shade800,
                                                width: 3),
                                          )),
                                      onPressed: () async {
                                        /** This will only be valid iff both of
                                    * the validators above return null
                                    */
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            loading = true;
                                          });
                                          dynamic result = await _auth
                                              .registerEP(email, password);

                                          /** result (from Future) is either String type or SpotterUser type */
                                          if (result is! SpotterUser) {
                                            setState(() {
                                              Fluttertoast.showToast(
                                                  msg: result,
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 5,
                                                  backgroundColor: Colors.black,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                              loading = false;
                                            });
                                          } else {
                                            if (!mounted) return;
                                            Navigator.of(context).pop();

                                            //_db.makeCollection(result.uid);
                                          }
                                        }
                                      },
                                      child: const Center(
                                        child: Text("Sign up",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)),
                                      ))),
                              const SizedBox(height: 25),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Have an account?"),
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          signup = false;
                                        });
                                      },
                                      child: Text("Sign in",
                                          style: TextStyle(
                                              color: Colors.blue.shade800,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)))
                                ],
                              ),
                            ],
                            const SizedBox(height: 12),
                            Text(error,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 14)),
                          ],
                        ))),
              ));
  }
}
