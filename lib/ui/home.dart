import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:leaf_for_reddit/service/reddit_service.dart';
import 'package:leaf_for_reddit/service/session_service.dart';
import 'package:leaf_for_reddit/ui/components/action_bar.dart';
import 'package:leaf_for_reddit/ui/components/app_bar.dart';
import 'package:leaf_for_reddit/ui/components/bottom_bar.dart';
import 'package:leaf_for_reddit/ui/components/feed.dart';
import 'package:leaf_for_reddit/ui/post_page.dart';
import 'package:reddit/reddit.dart';
import 'package:rxdart/subjects.dart';

class HomeWidget extends StatefulWidget {
  final HomeBloc _homeBloc;
  final void Function(BuildContext bContext) _iconButtonAction;

  HomeWidget(this._homeBloc, this._iconButtonAction, {Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with AfterLayoutMixin<HomeWidget>{
  AnimatedAppBar _appBar;
  Feed _feed;
  AnimatedBottomAppBar _bottomAppBar;

  @override
  void initState() {
    super.initState();

    _appBar = new AnimatedAppBar(
      new StreamBuilder(
        stream: widget._homeBloc.title,
        builder: (context, snapshot) => new Text(snapshot.data),
      ),
      <Widget>[
        new IconButton(
            icon: new Icon(
              Icons.account_circle,
              color: Colors.white,
            ),
            onPressed: () => widget._iconButtonAction(context))
      ],
    );

    _feed = new Feed(widget._homeBloc.feedItems);

    _bottomAppBar = new AnimatedBottomAppBar();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _appBar,
      body: new Center(
        child: _feed,
      ),
      floatingActionButton: new ActionBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _bottomAppBar,
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _appBar.hidden = false;
    _bottomAppBar.hidden = false;
  }
}

class HomeBloc {
  final _feedItemsSubject = new BehaviorSubject<List<FeedItemBloc>>();

  final _titleSubject = new BehaviorSubject<String>(seedValue: 'Leaf');
  Future<Reddit> _futureReddit;

  final RedditService _redditService;
  final PostPageBloc postPageBloc;
  final BuildContext _context;

  HomeBloc(this._context, SessionService sessionService, this._redditService,
      {this.postPageBloc}) {
    _redditService.redditStream.listen((futureReddit) {
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
          .map<FeedItemBloc>(
              (child) => new FeedItemBloc(child['data'], _openPost))
          .toList();
    });
    _feedItemsSubject.add(results);
  }

  // TODO: Move to HomeWidget since this is UI logic
  void _openPost(FeedItemBloc feedItemBloc) {
    postPageBloc.next(feedItemBloc);
    Navigator.pushNamed(_context, '/post');
  }

  Stream<String> get title => _titleSubject.stream;

  Stream<List<FeedItemBloc>> get feedItems => _feedItemsSubject.stream;
}

