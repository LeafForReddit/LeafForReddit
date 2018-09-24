import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:leaf_for_reddit/service/reddit_service.dart';
import 'package:leaf_for_reddit/service/session_service.dart';
import 'package:leaf_for_reddit/ui/components/action_bar.dart';
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
      bottomNavigationBar: new BottomBarWidget(),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _appBar.hidden = false;
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

class AnimatedAppBar extends StatefulWidget implements PreferredSizeWidget {
  final AppBar _child;
  final _hidden = BehaviorSubject<bool>();

  AnimatedAppBar(Widget title, List<Widget> actions)
      : _child = new AppBar(
          centerTitle: true,
          title: title,
          actions: actions,
        );

  @override
  State<StatefulWidget> createState() => new _AnimatedAppBarState(_child);

  @override
  Size get preferredSize => _child.preferredSize;

  set hidden(bool hidden) => _hidden.add(hidden);

  Stream<bool> get hiddenStream => _hidden.stream;

  void dispose() {
    _hidden.close();
  }
}

class _AnimatedAppBarState extends State<AnimatedAppBar>
    with SingleTickerProviderStateMixin {
  static final Animatable<Offset> _positionTween = Tween<Offset>(
    begin: const Offset(0.0, -1.0),
    end: Offset.zero,
  ).chain(CurveTween(curve: Curves.easeInOut));

  AnimationController _controller;

  Widget child;

  bool _hidden = true;

  _AnimatedAppBarState(this.child);

  @override
  void initState() {
    super.initState();
    widget.hiddenStream.listen(_transition);
    _controller = new AnimationController(
      duration: const Duration(milliseconds: 2400),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new SlideTransition(
      position: _positionTween.animate(_controller),
      child: child,
    );
  }

  void _transition(bool hidden) {
    if (hidden != _hidden) {
      _hidden = hidden;
      if (hidden) {
        print('Playing animation reverse');
//        _controller.reverse();
      } else {
        print('Playing animation forward');
        _controller.forward();
      }
    }
  }
}
