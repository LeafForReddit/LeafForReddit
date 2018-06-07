import 'dart:async';

import 'package:leaf_for_reddit/config/config_manager.dart';
import 'package:rxdart/subjects.dart';

class UserInformationManager {
  final _UserBundle userBundle = _UserBundle();

  Sink<User> get changeUser => _unController.sink;
  final _unController = StreamController<User>();

  final _currentUser = BehaviorSubject<User>();

  Stream<User> get currentUser => _currentUser.stream;

  final _userList = BehaviorSubject<Set<String>>();

  Stream<Set<String>> get userSet => _userList.stream;

  UserInformationManager() {
    _unController.stream.listen((user) {
      if (userBundle.currentUser != user) {
        //TODO implement setter
        userBundle.currentUser = user;
      }
//      if (!userBundle.userSet.contains(user)) {
//        userBundle.userSet.add(user);
//        _userList.add(userBundle.userSet);
//      }
    });
  }

  void dismiss() {
    _unController.close();
    _currentUser.close();
    _userList.close();
  }
}

class _UserBundle {
  final ConfigBundle _bundle = ConfigManager().getBundle(BundleToken.userInfo);
  User _currentUser;
  Set<User> userSet;

  _UserBundle() {
    if (_bundle != null) {
      _bundle.getVal('currentUser', (s) => User.fromString(s));
    }
    //TODO Figure out userSet
  }

  User get currentUser => _currentUser;

  set currentUser(User switchTo) {
    // TODO check user is in set

    currentUser = switchTo;
    _bundle.setVal('currentUser', switchTo);
  }
}

class User {
  String username;
  String imageUrl;

  User(this.username, this.imageUrl);

  User.fromString(String s) {
    //TODO implement properly
    username = 'XXX2';
  }
}
