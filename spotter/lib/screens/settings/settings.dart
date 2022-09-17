import 'package:flutter/material.dart';
import 'package:spotter/services/auth.dart';
import '../../backup.dart';

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
    );
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            child: Text('Settings'),
          ),
          ListTile(
            title: const Text('Backup'),
            onTap: () {
              debugPrint("Backup tapped");
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
            title: const Text('About'),
            trailing: const Icon(Icons.info),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => aboutPopup);
            },
          ),
          ElevatedButton(
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
