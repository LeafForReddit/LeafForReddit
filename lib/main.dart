import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:leaf_for_reddit/config/reddit_config.dart';
import 'package:leaf_for_reddit/service/reddit_service.dart';
import 'package:leaf_for_reddit/service/session_service.dart';
import 'package:leaf_for_reddit/ui/components/overlays.dart';
import 'package:leaf_for_reddit/ui/home.dart';
import 'package:leaf_for_reddit/ui/post_page.dart';
import 'package:leaf_for_reddit/ui/user_profile_view.dart';
import 'package:reddit/reddit.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var sessionService = new SessionService();
    var postPageBloc = new PostPageBloc();

    return new MaterialApp(
      title: 'Leaf For Reddit',
      theme: new ThemeData(
        primaryColor: Colors.green,
      ),
      routes: {
        '/': (context) => new HomeWidget(
              new HomeBloc(
                context,
                sessionService,
                new RedditService(
                  new Reddit(new Client()),
                  new RedditConfig(),
                  sessionService,
                ),
                postPageBloc: postPageBloc,
              ),
              (bContext) => BottomSheetTemplate.summonModal(
                    bContext,
                    child: new UserPageWidget(
                      new UserPageBloc(sessionService),
                    ),
                  ),
            ),
        '/post': (context) => new PostPageWidget(
              postPageBloc,
            ),
      },
    );
  }
}
