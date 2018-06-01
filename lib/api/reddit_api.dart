import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:secure_string/secure_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'reddit_oauth_config.dart';

class RedditOAuth {
  RedditOAuthConfig _config;
  String _basicHttpAuth;
  String _bearerToken;

  RedditOAuth(config) {
    _config = config;

    final bytes = utf8.encode("${_config.clientId}:");
    _basicHttpAuth = "basic ${base64.encode(bytes)}";
  }

  void authorise(BuildContext context) {
    final RedditOAuthConfig config = new RedditOAuthConfig();
    final SecureString secureString = new SecureString();
    final String state = secureString.generate(length: 64);
    final String authUrl =
        "https://www.reddit.com/api/v1/authorize?client_id=${config.clientId}"
        "&response_type=${config.responseType}"
        "&state=$state&redirect_uri=${config.redirectUri}"
        "&duration=${config.duration}&scope=identity,edit";

    new MaterialApp(
      routes: {
        "/": (_) => new WebviewScaffold(
              url: "http://www.google.com",
              appBar: new AppBar(
                title: new Text("Webview"),
              ),
            )
      },
    );
    final webView = new FlutterWebviewPlugin();
    webView.launch(authUrl,
        rect: new Rect.fromLTWH(
            0.0, 0.0, MediaQuery.of(context).size.width, 300.0));

    webView.onUrlChanged.listen((String url) {
      List<String> urlComponents = url.split("/?");

      if (urlComponents[0] == config.redirectUri) {
        Map<String, String> params = Uri.splitQueryString(urlComponents[1]);
        if (params["state"] == state) {
          _retrieveToken(params["code"]);
          webView.close();
        }
      }
    });
  }

  void refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String refreshToken = prefs.getString("refresh_token");
    http.post(_config.tokenUrl, headers: {
      "Authorization": _basicHttpAuth
    }, body: {
      "grant_type": "refresh_token",
      "refresh_token": refreshToken
    }).then((response) {
      final Map<String, String> body = json.decode(response.body);
      _bearerToken = body["access_token"];
    });
  }

  void _retrieveToken(String code) {
    http.post(
      _config.tokenUrl,
      headers: {"Authorization": _basicHttpAuth},
      body: {
        "grant_type": "authorization_code",
        "code": code,
        "redirect_uri": _config.redirectUri
      },
    ).then((response) async {
      final Map<String, String> body = json.decode(response.body);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("refresh_token", body["refresh_token"]);
      _bearerToken = body["access_token"];
      print(response.body);
    });
  }
}
