import 'dart:async';

import 'package:flutter/material.dart';
import 'package:leaf_for_reddit/service/session_service.dart';
import 'package:rxdart/subjects.dart';

class UserPageWidget extends StatelessWidget {
  UserPageBloc _userPageBloc;

  UserPageWidget(this._userPageBloc);

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        profileWidget(),
      ],
    );
  }

  Widget profileWidget() {
    return new Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: StreamBuilder<String>(
        stream: _userPageBloc.currentUser,
        builder: (context, snapshot) => new Card(
              child: new ListTile(
                leading: new Image.network(
                  'https://github.com/flutter/website/blob/master/_includes/code/layout/lakes/images/lake.jpg?raw=true',
                  height: 76.0,
                  width: 76.0,
                ),
                title: Text('u/${(snapshot.data != null)
                ? snapshot.data
                : 'XXXX'}'),
                trailing: const Icon(Icons.settings),
              ),
            ),
      ),
    );
  }
}

class UserPageBloc {
  final _currentUserSubject = new BehaviorSubject<String>();

  UserPageBloc(SessionService sessionService) {
    sessionService.currentUser
        .listen((user) => _currentUserSubject.add(user.username));
  }

  Stream<String> get currentUser => _currentUserSubject.stream;
}
