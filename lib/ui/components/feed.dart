import 'dart:async';

import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Feed extends StatelessWidget {
  final Stream<List<FeedItemBloc>> _items;

  Feed(this._items);

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
      ),
      child: new StreamBuilder(
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
                  return new ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) =>
                        new FeedItem(snapshot.data[index]),
                  );
                }
            }
          }),
    );
  }
}

class FeedItem extends StatelessWidget {
  final FeedItemBloc feedItemBloc;

  FeedItem(this.feedItemBloc);

  @override
  Widget build(BuildContext context) {
    return new Slidable(
      delegate: new SlidableBehindDelegate(),
      actionExtentRatio: 0.15,
      child: new ConstrainedBox(
        constraints: new BoxConstraints(
          minHeight: 120.0,
        ),
        child: new Container(
          color: Colors.white,
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: new Row(
            children: <Widget>[
              new ThumbnailWidget(feedItemBloc.thumbnailUri),
              new TextBlockWidget(
                feedItemBloc.title,
                feedItemBloc.subreddit,
                feedItemBloc.poster,
                feedItemBloc.posted,
                0.toString(),
              )
            ],
          ),
        ),
      ),
      actions: <Widget>[
        new IconSlideAction(icon: Icons.share),
      ],
      secondaryActions: <Widget>[
        new IconSlideAction(icon: Icons.arrow_downward),
        new IconSlideAction(icon: Icons.arrow_upward),
      ],
    );
  }
}

class FeedItemBloc {
  String title;
  String thumbnailUri;
  String poster;
  String posted;
  String subreddit;
  String id;

  FeedItemBloc(Map<String, dynamic> feedItemData) {
    title = feedItemData[_FeedItemKeys.title];
    thumbnailUri = feedItemData[_FeedItemKeys.thumbnail];
    poster = feedItemData[_FeedItemKeys.author];
    subreddit = feedItemData[_FeedItemKeys.subreddit];
    posted = _calcElapsedTime(feedItemData[_FeedItemKeys.created]);
    id = feedItemData[_FeedItemKeys.id];
  }

  static String _calcElapsedTime(double epocPostTime) {
    int diff = new DateTime.now()
        .difference(new DateTime.fromMillisecondsSinceEpoch(
            (epocPostTime * 1000).floor(),
            isUtc: true))
        .inHours;

    return '${diff.toString()} ${(diff == 1) ? 'hour' : 'hours'} ago';
  }
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
}

class ThumbnailWidget extends StatelessWidget {
  final String _imageUri;

  ThumbnailWidget(this._imageUri);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: _imageUri,
        fit: BoxFit.cover,
        height: 88.0,
        width: 88.0,
      ),
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
    );
  }
}

class TextBlockWidget extends StatelessWidget {
  final String _title;
  final String _subreddit;
  final String _poster;
  final String _posted;
  final String _commentNo;

  TextBlockWidget(this._title, this._subreddit, this._poster, this._posted,
      this._commentNo);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        verticalDirection: VerticalDirection.down,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Text(
            '$_subreddit by $_poster',
            style: TextStyle(
              fontSize: 10.0,
              color: Colors.grey,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          new Container(
            child: new Text(
              _title,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
              softWrap: true,
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          new Text(
            '${_commentNo} comments * ${_posted}',
            style: TextStyle(
              fontSize: 10.0,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          )
        ],
      ),
    );
  }
}
