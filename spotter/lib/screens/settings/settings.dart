import 'package:flutter/material.dart';
import 'package:spotter/screens/settings/settings_sign_in.dart';
import 'package:spotter/services/auth_service.dart';
import 'package:spotter/main.dart';
// import 'package:google_sign_in/google_sign_in.dart';
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
                const Text(
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
                  const SizedBox(
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
                          if (_auth.currentUser!.isAnon!) {
                            return showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Are you sure?'),
                                    content: const SizedBox(
                                      height: 100,
                                      child: Text(
                                          'If you sign out now your data will be lost unless an account is created.\n\nDo you wish to proceed?'),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () async {
                                            objectbox.taskGroups.removeAll();
                                            objectbox.taskDate.removeAll();
                                            objectbox.taskList.removeAll();

                                            await _auth.deleteUser();
                                            await objectbox.taskCollection
                                                .doc(userUid!)
                                                .delete()
                                                .then((value) =>
                                                    Navigator.popUntil(
                                                        context,
                                                        ModalRoute.withName(
                                                            "/")));
                                          },
                                          child: const Text('Log me out')),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Take me back')),
                                    ],
                                  );
                                });
                          }
                          await _auth.signOut();
                          if (!mounted) return;
                          Navigator.popUntil(context, ModalRoute.withName("/"));
                        },
                        child: const Text('Log Out')),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          );
  }
}
