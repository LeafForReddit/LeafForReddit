import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:uuid/uuid.dart';

class SessionService {
  final _currentSubredditSubject = new BehaviorSubject<String>(seedValue: 'Popular');
  final _currentDeviceIdSubject = new BehaviorSubject<String>(seedValue: new Uuid().v4());

  Stream<String> get currentSubreddit => _currentSubredditSubject.stream;

  Stream<String> get currentDeviceId => _currentDeviceIdSubject.stream;
}