import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:leaf_for_reddit/config/reddit_config.dart';
import 'package:leaf_for_reddit/service/reddit_service.dart';
import 'package:leaf_for_reddit/service/session_service.dart';
import 'package:leaf_for_reddit/ui/home_view.dart';
import 'package:reddit/reddit.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var sessionService = new SessionService();

    return new MaterialApp(
      title: 'Leaf For Reddit',
      theme: new ThemeData(
        primaryColor: Colors.green,
      ),
      home: new Home(
        new HomeBloc(
          sessionService,
          new RedditService(
            new Reddit(new Client()),
            new RedditConfig(),
            sessionService,
          ),
        ),
      ),
    );
  }
}
