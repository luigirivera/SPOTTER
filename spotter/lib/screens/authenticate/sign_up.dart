import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/auth.dart';
import '../loading/loading.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool hidePassword = true;

  ///This is used with the 'Sign up' button
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue.shade200,
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text("Sign up"),
        ),
        body: _loading
            ? const Loading()
            : SafeArea(
                child: Center(
                    child: Form(

                        ///Using _formKey here
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            const Text("Sign Up",
                                style: TextStyle(fontSize: 30)),
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
                                            width: 2),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      hintText: "Email",
                                      filled: true,
                                      fillColor: Colors.grey.shade200),
                                  /** Help in validating formats */
                                  validator: (value) =>
                                      value!.isEmpty ? 'Enter an email' : null,
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
                                            width: 2),
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

                                  /** Help validating formats */
                                  validator: (value) => value!.length < 6
                                      ? 'Enter a password 6+ chars long'
                                      : null,
                                  onChanged: (value) {
                                    setState(() => password = value);
                                  },
                                )),

                            ///The sign up button section
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: Colors.blue.shade800,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
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
                                        _loading = true;
                                      });
                                      dynamic result = await _auth.registerEP(
                                          email, password);

                                      /** result (from Future) is either String type or SpotterUser type */
                                      if (result is! SpotterUser) {
                                        setState(() {
                                          Fluttertoast.showToast(
                                              msg: result,
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 5,
                                              backgroundColor: Colors.black,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                          _loading = false;
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
                                  )),
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
