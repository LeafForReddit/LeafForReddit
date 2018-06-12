import 'package:flutter/material.dart';
import 'package:leaf_for_reddit/api/reddit_client.dart';
import 'package:leaf_for_reddit/official_themes.dart';
import 'package:reddit/reddit.dart';
import 'package:transparent_image/transparent_image.dart';

class SubList extends StatefulWidget {
  final RedditClient _client;

  SubList(this._client);

  @override
  State<StatefulWidget> createState() {
    return new _SubListState();
  }
}

class _SubListState extends State<SubList> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: FutureBuilder<ListingResult>(
        future: widget._client.fetchSubreddit('popular'),
        builder: (context, snapshot) => new ListView(
              children: snapshot.data['data']['children']
                  .map<FeedItem>((child) => new FeedItem(child['data']))
                  .toList(),
            ),
      ),
    );
  }
}

class FeedItem extends StatefulWidget {
  final Map<String, dynamic> _listItem;

  FeedItem(this._listItem, {Key key}) : super(key: key);

  @override
  _FeedItemState createState() => new _FeedItemState();
}

class _FeedItemState extends State<FeedItem> {
  int _votestatus = 0;
  bool _isSwiped = false;

  @override
  Widget build(BuildContext context) {
    return new ConstrainedBox(
      constraints: new BoxConstraints(
        minHeight: 120.0,
      ),
      child: new Container(
        padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
        child: new Row(
          children: <Widget>[
            new _UpvoteWidget(
              voteCount: widget._listItem['ups'],
              userVoteStatus: _votestatus,
              voteChange: newUserVote,
            ),
            new ThumbnailWidget(
              imageUri: widget._listItem['thumbnail'],
            ),
            new TextBlockWidget(
              widget._listItem['title'],
              widget._listItem['subreddit_name_prefixed'],
              widget._listItem['author'],
              widget._listItem['created_utc'],
              widget._listItem['num_comments'],
            ),
          ],
        ),
      ),
    );
  }

  void newUserVote(int vote) {
    // TODO Implement remote update logic
    setState(() {
      _votestatus = vote;
    });
  }
}

class TextBlockWidget extends StatelessWidget {
  final String _title;
  final String _subreddit;
  final String _poster;
  final double _posted;
  final int _commentNo;

  TextBlockWidget(this._title, this._subreddit, this._poster, this._posted,
      this._commentNo);

  @override
  Widget build(BuildContext context) {
    return new Column(
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
              fontSize: 16.0,
            ),
            softWrap: true,
            maxLines: 3,
          ),
        ),
        new Text(
          '${_commentNo.toString()} comments * ${_calcElapsedTime(_posted)}',
          style: TextStyle(
            fontSize: 10.0,
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        )
      ],
    );
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

class ThumbnailWidget extends StatelessWidget {
  final String imageUri;

  ThumbnailWidget({this.imageUri});

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: imageUri,
        fit: BoxFit.cover,
        height: 88.0,
        width: 88.0,
      ),
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
    );
  }
}

class _UpvoteWidget extends StatelessWidget {
  final int voteCount;
  final int userVoteStatus;

  final ValueChanged<int> voteChange;

  _UpvoteWidget(
      {@required this.voteCount,
      @required this.userVoteStatus,
      @required this.voteChange});

  void _votePress(int status) {
    var newStatus = (status == userVoteStatus) ? 0 : status;
    voteChange(newStatus);
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        new GestureDetector(
          child: new Icon(
            Icons.keyboard_arrow_up,
            color: (userVoteStatus > 0) ? LeafColors.upvote_color : null,
          ),
          onTap: () => _votePress(1),
        ),
        new Text(
          _formatUps(voteCount),
          style: new TextStyle(
            color: (userVoteStatus > 0)
                ? LeafColors.upvote_color
                : ((userVoteStatus < 0) ? LeafColors.downvote_color : null),
          ),
        ),
        new GestureDetector(
          child: new Icon(
            Icons.keyboard_arrow_down,
            color: (userVoteStatus < 0) ? LeafColors.downvote_color : null,
          ),
          onTap: () => _votePress(-1),
        ),
      ],
    );
  }

  //TODO Consider use of bloc for this element and moving this method there
  static String _formatUps(int ups) =>
      (ups < 1000) ? ups.toString() : '${(ups / 1000).floor()}k';
}
