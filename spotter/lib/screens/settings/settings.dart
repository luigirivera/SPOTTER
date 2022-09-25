import 'package:flutter/material.dart';
import 'package:spotter/services/auth.dart';

class SettingsDrawer extends StatefulWidget {
  const SettingsDrawer({Key? key}) : super(key: key);

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
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
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            child: Text('Settings'),
          ),
          // ListTile(
          //   title: const Text('Dark Mode'),
          //   trailing: Switch(
          //     value: true,
          //     onChanged: (value) {},
          //   ),
          // ),
          if (_auth.currentUser!.isAnon == true)
            ListTile(
              title: const Text('Backup'),
              onTap: () {
                print("Backup");
              },
            ),
          ListTile(
            title: const Text('About'),
            trailing: const Icon(Icons.info),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => aboutPopup);
            },
          ),

          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.black,
                  //rounded corners
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.black, width: 2))),
              onPressed: () async {
                await _auth.signOut();
                if (!mounted) return;
                Navigator.popUntil(context, ModalRoute.withName("/"));
              },
              child: const Text('Log Out')),
        ],
      ),
    );
  }
}
