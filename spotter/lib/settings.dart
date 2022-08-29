import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            child: Text('Settings'),
          ),
          ListTile(
            title: const Text('Dark Mode'),
            onTap: () => print("Dark mode tapped"),
          ),
          // ListTile(
          //   title: const Text('Dark Mode'),
          //   trailing: Switch(
          //     value: true,
          //     onChanged: (value) {},
          //   ),
          // ),
          ListTile(
            title: const Text('Notifications'),
            trailing: Switch(
              value: true,
              onChanged: (value) {},
            ),
          ),
          ListTile(
            title: const Text('About'),
            trailing: const Icon(Icons.info),
          ),
        ],
      ),
    );
  }
}
