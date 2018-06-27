import 'package:flutter/material.dart';
import 'package:notodoapp/ui/notodoscreen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("NoToDo"),
      ),
      body: new Notodoscreen(),
    );
  }

}

