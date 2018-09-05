import 'dart:async';

import 'package:leaf_for_reddit/config/reddit_config.dart';
import 'package:leaf_for_reddit/service/session_service.dart';
import 'package:reddit/reddit.dart';
import 'package:rxdart/subjects.dart';

class RedditService {
  final _reddit = new BehaviorSubject<Future<Reddit>>();
  final RedditConfig _config;

  RedditService(Reddit reddit, this._config, SessionService sessionService) {
    reddit.authSetup(_config.clientId);
    sessionService.currentDeviceId
        .listen((deviceId) => _finishAuth(deviceId, reddit: reddit));
  }

  void _finishAuth(String deviceId, {Reddit reddit}) async {
    Reddit toAuth = reddit ?? (await _reddit.value);
//    print('Auth: ' + toAuth.toString());
    _reddit.add(toAuth.authFinish(deviceId: deviceId));
//    print('Reddit: ' + reddit.toString());
  }

  Stream<Future<Reddit>> get redditStream => _reddit.stream;
}
