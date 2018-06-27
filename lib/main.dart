import 'package:flutter/material.dart';
import 'package:notodoapp/ui/home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'No To Do',
      theme: new ThemeData.dark(),
      home: new Home(),
    );
  }
}

