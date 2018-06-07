import 'package:flutter/material.dart';
import 'package:leaf_for_reddit/ui/home.dart';

import 'package:leaf_for_reddit/ui/bloc/user_service.dart';

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


