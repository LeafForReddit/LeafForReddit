import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class Feed extends StatelessWidget {
  final Stream<List<FeedItemBloc>> _items;

  Feed(this._items);

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: _items,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            // TODO Replace with loading screen
            return new Container();
          default:
            if (snapshot.hasError) {
              return new Text('Error: ${snapshot.error}');
            } else {
              return new ListView.separated(
                itemCount: snapshot.data.length,
                separatorBuilder: (context, index) => new Divider(
                      color: Colors.black54,
                      height: 0.0,
                    ),
                itemBuilder: (context, index) =>
                    new _FeedItem(snapshot.data[index]),
              );
            }
        }
      },
    );
  }
}

class _FeedItem extends StatelessWidget {
  final FeedItemBloc _feedItemBloc;

  _FeedItem(this._feedItemBloc);

  @override
  Widget build(BuildContext context) {
    return new Slidable(
      delegate: new SlidableBehindDelegate(),
      actionExtentRatio: 0.15,
      child: new Container(
        color: Colors.white,
        child: new _ListItem(
          leading: (!_feedItemBloc.hasThumbnail)
              ? new _ThumbnailWidget(_feedItemBloc.thumbnailUri)
              : null,
          title: new Text(_feedItemBloc.title),
          subtitle: new Text(_feedItemBloc.subreddit),
          trailing: new _TrailingWidget(
            _feedItemBloc.ups.toString(),
            _feedItemBloc.commentNo.toString(),
          ),
        ),
      ),
      actions: <Widget>[
        new IconSlideAction(
          icon: Icons.share,
          onTap: () => _feedItemBloc.share(),
        ),
      ],
      secondaryActions: <Widget>[
        new IconSlideAction(icon: Icons.arrow_upward),
        new IconSlideAction(icon: Icons.arrow_downward),
      ],
    );
  }
}

class FeedItemBloc {
  static final String _redditUrl = 'www.reddit.com';
  static final String _defaultThumbnail = 'default';

  String title;
  String thumbnailUri;
  String poster;
  String posted;
  String subreddit;
  String id;
  int ups;
  String commentNo;
  String postUrl;

  FeedItemBloc(Map<String, dynamic> feedItemData) {
    title = feedItemData[_FeedItemKeys.title];
    thumbnailUri = feedItemData[_FeedItemKeys.thumbnail];
    poster = feedItemData[_FeedItemKeys.author];
    subreddit = feedItemData[_FeedItemKeys.subreddit];
    posted = _calcElapsedTime(feedItemData[_FeedItemKeys.created]);
    id = feedItemData[_FeedItemKeys.id];
    ups = feedItemData[_FeedItemKeys.ups];
    commentNo = feedItemData[_FeedItemKeys.commentNo].toString();
    postUrl = _redditUrl + feedItemData[_FeedItemKeys.postUrl];
  }

  static String _calcElapsedTime(double epocPostTime) {
    int diff = new DateTime.now()
        .difference(new DateTime.fromMillisecondsSinceEpoch(
            (epocPostTime * 1000).floor(),
            isUtc: true))
        .inHours;

    return '${diff.toString()} ${(diff == 1) ? 'hour' : 'hours'} ago';
  }

  bool get hasThumbnail => thumbnailUri == _defaultThumbnail;

  void share() => new Share.plainText(text: postUrl).share();
}

abstract class _FeedItemKeys {
  static const ups = 'ups';
  static const thumbnail = 'thumbnail';
  static const title = 'title';
  static const subreddit = 'subreddit_name_prefixed';
  static const author = 'author';
  static const created = 'created_utc';
  static const commentNo = 'num_comments';
  static const likes = 'likes';
  static const id = 'id';
  static const postUrl = 'permalink';
}

class _ThumbnailWidget extends StatelessWidget {
  final String _imageUri;

  _ThumbnailWidget(this._imageUri);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: _imageUri,
        fit: BoxFit.cover,
        height: 72.0,
        width: 88.0,
      ),
    );
  }
}

class _ListItem extends ListTile {
  final double _tileHeight = 88.0;

  _ListItem({
    Widget leading,
    Widget title,
    Widget subtitle,
    Widget trailing,
  }) : super(
          isThreeLine: true,
          leading: leading,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
        );

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: null,
      onLongPress: null,
      child: new Semantics(
        selected: selected,
        enabled: enabled,
        child: new ConstrainedBox(
          constraints: new BoxConstraints(minHeight: _tileHeight),
          child: new Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: new UnconstrainedBox(
              constrainedAxis: Axis.horizontal,
              child: new SafeArea(
                top: false,
                bottom: false,
                child: new Row(
                  children: _getChildren(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getChildren() {
    List<Widget> children = new List();

    // Check if post should have thumbnail
    if (leading != null) {
      children.add(
        new Container(
          margin: const EdgeInsetsDirectional.only(end: 16.0),
          alignment: AlignmentDirectional.centerStart,
          child: leading,
        ),
      );
    }

    // Title + subreddit
    children.add(
      new Expanded(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new AnimatedDefaultTextStyle(
              child: title,
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.black87,
              ),
              duration: kThemeChangeDuration,
            ),
            new AnimatedDefaultTextStyle(
              child: subtitle,
              style: new TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
                fontSize: 10.0,
              ),
              duration: kThemeChangeDuration,
            )
          ],
        ),
      ),
    );

    // Upvotes + comments
    children.add(
      new Container(
        margin: const EdgeInsetsDirectional.only(start: 16.0),
        alignment: AlignmentDirectional.centerEnd,
        child: trailing,
      ),
    );

    return children;
  }
}

class _TrailingWidget extends StatelessWidget {
  final TextStyle textStyle = new TextStyle(
    fontSize: 11.0,
    color: Colors.grey,
  );

  final String _voteScore;
  final String _commentNo;

  _TrailingWidget(this._voteScore, this._commentNo);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Row(
          children: <Widget>[
            new Icon(
              Icons.arrow_upward,
              size: 18.0,
              color: Colors.grey,
            ),
            new Text(
              _voteScore,
              style: textStyle,
            ),
          ],
        ),
        new Divider(
          color: Colors.black,
          height: 2.0,
        ),
        new Row(
          children: <Widget>[
            new Icon(
              Icons.comment,
              size: 18.0,
              color: Colors.grey,
            ),
            new Text(
              _commentNo,
              style: textStyle,
            ),
          ],
        )
      ],
    );
  }
}
