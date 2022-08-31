import 'package:flutter/material.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        height: 300.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Spotter - Tasks Companion"),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'COMP 499 Capstone Project',
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'By Arze Lu and Louie Rivera',
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 40.0)),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Done',
                  style: TextStyle(color: Colors.black, fontSize: 18.0),
                ))
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
          ListTile(
            title: const Text('Statistics'),
            onTap: () => print("Statistics tapped"),
          ),
          ListTile(
            title: const Text('Backup'),
            onTap: () => print("Backup tapped"),
          ),
          // ListTile(
          //   title: const Text('Dark Mode'),
          //   trailing: Switch(
          //     value: true,
          //     onChanged: (value) {},
          //   ),
          // ),
          ListTile(
            title: Text('About'),
            trailing: Icon(Icons.info),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => errorDialog);
            },
          ),
        ],
      ),
    );
  }
}
