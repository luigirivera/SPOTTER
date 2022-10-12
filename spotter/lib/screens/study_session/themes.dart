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
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, "Back");
            },
            icon: const Icon(Icons.arrow_back)),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/sea_appbar.png'),
            fit: BoxFit.fill,
          )),
        ),
      ),
      body: const Center(
        child: Text('Themes'),
      ),
    );
  }
}
