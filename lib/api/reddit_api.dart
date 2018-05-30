import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:secure_string/secure_string.dart';

import 'reddit_oauth_config.dart';

Future<http.Response> fetchPost() async {
  final _url = "http://www.reddit.com/r/android/hot";
  print(_url);
  final r = await http.get(_url);
  final responseJson = json.decode(r.body);
  print(r);
  return http.get(_url);
}

void openWebView(BuildContext context) {
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
        final bytes = utf8.encode("${config.clientId}:");
        final String authHeader = "basic ${BASE64.encode(bytes)}";
        http.post(
          "https://www.reddit.com/api/v1/access_token",
          headers: {"Authorization": authHeader},
          body: {
            "grant_type": "authorization_code",
            "code": params["code"],
            "redirect_uri": config.redirectUri
          },
        ).then((response) {
        final body = response.body;
          print(response.body);
          webView.close();
        });
        print("URL is: $url");
      }
    }
  });
}
