import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:uuid/uuid.dart';

class SessionService {
  final _currentSubredditSubject =
      new BehaviorSubject<String>(seedValue: 'Popular');
  final _currentUserSubject =
      new BehaviorSubject<User>(seedValue: new User('Text', new Uuid().v4()));

  Stream<String> get currentSubreddit => _currentSubredditSubject.stream;

  Stream<User> get currentUser => _currentUserSubject.stream;

  void dispose() {
    _currentUserSubject.close();
    _currentSubredditSubject.close();
  }
}

class User {
  final String username;
  final String deviceId;

  User(this.username, this.deviceId);
}
