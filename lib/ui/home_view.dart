import 'dart:async';

import 'package:flutter/material.dart';
import 'package:leaf_for_reddit/service/reddit_service.dart';
import 'package:leaf_for_reddit/service/session_service.dart';
import 'package:leaf_for_reddit/ui/components/action_bar.dart';
import 'package:leaf_for_reddit/ui/components/bottom_bar.dart';
import 'package:leaf_for_reddit/ui/components/feed.dart';
import 'package:reddit/reddit.dart';
import 'package:rxdart/subjects.dart';

class Home extends StatelessWidget {
  final HomeBloc _homeBloc;
  final void Function(BuildContext bContext) _iconButtonAction;

  Home(this._homeBloc, this._iconButtonAction, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new StreamBuilder<String>(
          stream: _homeBloc.title,
          builder: (context, snapshot) => new Text(snapshot.data),
        ),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.account_circle,
              color: Colors.white,
            ),
            onPressed: () => _iconButtonAction(context),
          ),
        ],
      ),
      body: new Center(
        child: new Feed(_homeBloc.feedItems),
      ),
      floatingActionButton: new ActionBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: new BottomBarWidget(),
    );
  }
}

class HomeBloc {
  final _feedItemsSubject = new BehaviorSubject<List<FeedItemBloc>>();

  final _titleSubject = new BehaviorSubject<String>(seedValue: 'Leaf');
  Future<Reddit> _futureReddit;

  HomeBloc(SessionService sessionService, RedditService redditService) {
    redditService.redditStream.listen((futureReddit) {
      _futureReddit = futureReddit;
    });

    sessionService.currentSubreddit
        .listen((currentSub) => _setSubredditResult(currentSub));
  }

  void _setSubredditResult(String title) async {
    _titleSubject.add(title);
    await _futureReddit;
    Reddit reddit = await _futureReddit;
    List<FeedItemBloc> results = await reddit
        .sub(title)
        .hot()
        .fetch()
        .then<List<FeedItemBloc>>((response) {
      return response['data']['children']
          .map<FeedItemBloc>((child) => new FeedItemBloc(child['data']))
          .toList();
    });
    _feedItemsSubject.add(results);
  }

  Stream<String> get title => _titleSubject.stream;

  Stream<List<FeedItemBloc>> get feedItems => _feedItemsSubject.stream;
}
