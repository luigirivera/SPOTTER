import 'package:flutter/material.dart';
import 'backup.dart';
import 'statistics.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Dialog aboutPopup = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        height: 150.0,
        width: 150.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
          ListTile(
            title: const Text('Statistics'),
            onTap: () {
              print("Statistics tapped");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const StatisticsScreen()));
            },
          ),
          ListTile(
            title: const Text('Backup'),
            onTap: () {
              print("Backup tapped");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BackupScreen()));
            },
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
                  builder: (BuildContext context) => aboutPopup);
            },
          ),
        ],
      ),
    );
  }
}
