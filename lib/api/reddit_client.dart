import 'dart:async';

import 'package:http/http.dart';
import 'package:leaf_for_reddit/api/reddit_oauth_config.dart';
import 'package:reddit/reddit.dart';
import 'package:uuid/uuid.dart';

class RedditClient {
  static RedditClient _self;

  RedditOAuthConfig _config;

  factory RedditClient(RedditOAuthConfig config) {
    if (_self == null) {
      _self = RedditClient._internal(config);
    }

    return _self;
  }

  RedditClient._internal(this._config);

  Future<ListingResult> fetchSubreddit(String sub) async {
    Reddit reddit = new Reddit(new Client());

    reddit.authSetup(_config.clientId);

    String deviceId = new Uuid().v4();
    await reddit.authFinish(deviceId: deviceId);

    return reddit.sub(sub).hot().fetch();
  }
}
