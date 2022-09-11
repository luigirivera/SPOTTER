import 'package:flutter/material.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({Key? key}) : super(key: key);

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Backup"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Center(
        child: Text("Backup"),
      ),
    );
  }
}
