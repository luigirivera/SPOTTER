import 'package:flutter/material.dart';
import 'package:spotter/screens/settings/settings_sign_in.dart';
import 'package:spotter/services/auth_service.dart';
import 'dart:io' show Platform;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../loading/loading.dart';

class SettingsDrawer extends StatefulWidget {
  const SettingsDrawer({Key? key}) : super(key: key);

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  final AuthService _auth = AuthService();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    //Dialog for Quitting as anon
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {
        _auth.signOut();
        if (!mounted) return;
        Navigator.popUntil(context, ModalRoute.withName("/"));
      },
    );

    // set up the AlertDialog
    AlertDialog anonQuitAlert = AlertDialog(
      title: Text("Log Out?"),
      content: Text(
          "Quitting from a Guest Account will result in losing all your data. Are you sure you want to continue?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    //Dialog for About
    Dialog aboutPopup = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: SizedBox(
        height: 150.0,
        width: 150.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text("Spotter - Tasks Companion"),
            Text('COMP 499 Capstone Project'),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'By Arze Lu and Louie Rivera',
              ),
            )
          ],
        ),
      ),
    );
    return loading
        ? const Loading()
        : Drawer(
            child: Column(
              children: [
                const SizedBox(
                  height: 70,
                ),
                Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                // const DrawerHeader(
                //   child: Text('Settings'),
                // ),

                ListTile(
                  title: const Text('About'),
                  trailing: const Icon(Icons.info),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => aboutPopup);
                  },
                ),

                if (_auth.currentUser!.isAnon == true)
                  SizedBox(
                    height: 30,
                  ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_auth.currentUser!.isAnon == true)
                      Column(
                        children: [
                          SignInButton(Buttons.GoogleDark, onPressed: () {
                            setState(() {
                              loading = true;
                            });
                            _auth.googleLogin().then((result) {
                              if (result == null) {
                                setState(() {
                                  loading = false;
                                });
                              }
                            });
                          }),
                          SignInButton(Buttons.Email, onPressed: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const SignIn()))
                                .then((value) => setState(() {}));
                          }),
                        ],
                      )
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.black,
                            //rounded corners
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                    color: Colors.black, width: 2))),
                        onPressed: () async {
                          if (_auth.currentUser!.isAnon == false) {
                            await _auth.signOut();
                            if (!mounted) return;
                            Navigator.popUntil(
                                context, ModalRoute.withName("/"));
                          } else {
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    anonQuitAlert);
                          }
                        },
                        child: const Text('Log Out')),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          );
  }
}
