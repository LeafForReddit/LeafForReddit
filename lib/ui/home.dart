import 'package:flutter/material.dart';
import 'package:leaf_for_reddit/api/reddit_oauth_config.dart';
import 'package:leaf_for_reddit/api/reddit_client.dart';
import 'package:leaf_for_reddit/ui/action_bar.dart';
import 'package:leaf_for_reddit/ui/bottom_bar.dart';
import 'package:leaf_for_reddit/ui/overlays.dart';
import 'package:leaf_for_reddit/ui/sub_list.dart';
import 'package:leaf_for_reddit/ui/user_profile.dart';
import 'package:leaf_for_reddit/ui/bloc/user_service.dart';

class Home extends StatefulWidget {
  final UserInformationManager _infoManager = UserInformationManager();

  // TODO Add dependency on _infoManager once implementation is done
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  String _title = 'Leaf';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(_title),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.account_circle, color: Colors.white,),
            onPressed: () =>
                BottomSheetTemplate.summonModal(
                    context, child: new UserOptionsWidget(widget._infoManager)),
          ),
        ],
      ),
      body: new Center(
        child: new SubList(new RedditClient(RedditOAuthConfig())),
      ),
      floatingActionButton: new ActionBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: new BottomBarWidget(),
    );
  }

  void newTitle(String newTitle) => setState(() => _title = newTitle);
}




