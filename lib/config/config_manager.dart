import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigManager {
  static ConfigManager _self;

  static final Map<BundleToken, ConfigBundle> _cache =
      <BundleToken, ConfigBundle>{};

  Future<SharedPreferences> _prefs;

  factory ConfigManager() {
    if (_self == null) {
      _self = ConfigManager._internal();
    }

    return _self;
  }

  ConfigBundle getBundle(BundleToken token) {
    if (!_cache.containsKey(token)) {
      _prefs
          .then((prefs) => prefs.getString(_bundleTokenToString[token]))
          .catchError((e) => print('Printing error: ${e.toString()}'));
    }

    return _cache[token];
  }

  ConfigManager._internal() {
    _prefs = SharedPreferences.getInstance();
  }
}

class ConfigBundle {
  final BundleToken _key;
  final Map<String, String> _bundle;

  ConfigBundle._(this._key, this._bundle);

  T getVal<T>(String key, T fromString(String s)) => fromString(_bundle[key]);

  String getString(String key) => _bundle[key];

  void setString(String key, String s) => _bundle[key] = s;

  void setVal<T>(String key, T val, {String toString(T)}) =>
      _bundle[key] = (toString != null) ? toString(val) : val.toString();
}

enum BundleToken {
  appConfig,
  tokenInfo,
  userInfo,
}

Map<BundleToken, String> _bundleTokenToString = <BundleToken, String>{
  BundleToken.appConfig: 'AppConfig',
  BundleToken.tokenInfo: 'TokenInfo',
  BundleToken.userInfo: 'UserInfo',
};
