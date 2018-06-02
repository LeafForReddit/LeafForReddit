import 'package:flutter/material.dart';

import 'home.dart';
import 'user_services.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Leaf For Reddit',
      theme: new ThemeData(
        primaryColor: Colors.green,
      ),
      home: new Home(),
    );
  }
}


