import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';

class Themes extends StatefulWidget {
  const Themes({Key? key}) : super(key: key);

  @override
  _ThemesState createState() => _ThemesState();
}

class _ThemesState extends State<Themes> {
  int _selectedIndex = -1;
  bool _newSelected = false;
  List<String> files = List.empty(growable: true);

  @override
  void initState() {
    loadThumbnails(context);
    super.initState();
  }

  loadThumbnails(BuildContext context) async
  {
    var assetsFile = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(assetsFile);

    List<String> thumbnails = manifestMap.keys.where((String key) => key.contains('assets/themes/thumbnails/') && key.contains('.png')).toList();

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
              Navigator.pop(context, _selectedIndex);
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
        children: files.map((file){
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = files.indexOf(file);
                _newSelected = true;
              });

              print(_selectedIndex);
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
