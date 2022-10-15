import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import '../../main.dart';
import '../../models/session_model.dart';

class Themes extends StatefulWidget {
  const Themes({Key? key}) : super(key: key);

  @override
  _ThemesState createState() => _ThemesState();
}

class _ThemesState extends State<Themes> {
  int _selectedIndex = objectbox.getTheme().index;
  String _selectedFolder = objectbox.getTheme().folder;
  String _selectedFile = objectbox.getTheme().name;

  List<String> files = List.empty(growable: true);
  List<String> folders = List.empty(growable: true);
  List<String> names = List.empty(growable: true);

  @override
  void initState() {
    loadThumbnails(context);
    super.initState();
  }

  loadThumbnails(BuildContext context) async {
    var assetsFile =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(assetsFile);

    List<String> thumbnails = manifestMap.keys
        .where((String key) =>
            key.contains('assets/themes/thumbnails/') && key.contains('.png'))
        .toList();

    folders = thumbnails.map((e) {
      return e
          .split(RegExp(r'assets/themes/thumbnails/'))[1]
          .split(RegExp(r'\.'))[0];
    }).toList();

    names = folders.map((e) {
      return e.split(RegExp(r'_'))[1].split(r'/')[0];
    }).toList();

    setState(() {
      files = List.generate(thumbnails.length, (index) => thumbnails[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Themes'),
        leading: IconButton(
            onPressed: () {
              objectbox.setTheme(StudyTheme(
                  index: _selectedIndex,
                  folder: _selectedFolder,
                  name: _selectedFile));
              Navigator.pop(context, false);
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
      body: Column(
        children: files.map((file) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = files.indexOf(file);
                _selectedFolder = folders[_selectedIndex];
                _selectedFile = names[_selectedIndex];
              });
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Image.asset(file),
            ),
          );
        }).toList(),
      ),
    );
  }
}
