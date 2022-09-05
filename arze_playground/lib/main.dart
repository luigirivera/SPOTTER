import 'package:flutter/material.dart';

void main() => runApp(new TestApp());

class TestApp extends StatefulWidget {
  @override
  _TestState createState() => new _TestState();
}

class _TestState extends State<TestApp> {
  String abc = "bb";

  callback(newAbc) {
    setState(() {
      abc = newAbc;
    });
  }

  @override
  Widget build(BuildContext context) {
    var column = new Column(
      children: <Widget>[
        new Text("This is text $abc"),
        TestApp2(abc, callback)
      ],
    );
    return new MaterialApp(
      home: new Scaffold(
        body: new Padding(padding: EdgeInsets.all(30.0), child: column),
      ),
    );
  }
}

class TestApp2 extends StatefulWidget {
  String abc;
  Function(String) callback;

  TestApp2(this.abc, this.callback, {Key? key}) : super(key: key);

  @override
  _TestState2 createState() => new _TestState2();
}

class _TestState2 extends State<TestApp2> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 150.0,
      height: 30.0,
      margin: EdgeInsets.only(top: 50.0),
      child: new TextButton(
        onPressed: () {
          widget.callback("RANDON TEXT"); //call to parent
        },
        child: new Text(widget.abc),
      ),
    );
  }
}
