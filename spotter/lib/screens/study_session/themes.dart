import 'package:flutter/material.dart';

class Themes extends StatefulWidget {
  const Themes({Key? key}) : super(key: key);

  @override
  _ThemesState createState() => _ThemesState();
}

class _ThemesState extends State<Themes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Themes'),
      ),
      body: const Center(
        child: Text('Themes'),
      ),
    );
  }
}
