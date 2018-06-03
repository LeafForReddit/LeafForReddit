import 'package:flutter/material.dart';
import 'package:leaf_for_reddit/official_themes.dart';
import 'package:transparent_image/transparent_image.dart';


class SubList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SubListState();
  }
}

class _SubListState extends State<SubList> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new ListView(
      children: <Widget>[
        new FeedItem('Hello World'),
        new FeedItem('Hello 2'),
      ],
    );
  }
}

class FeedItem extends StatefulWidget {
  final String uri;

  FeedItem(this.uri, {Key key}) : super(key: key);

  @override
  _FeedItemState createState() => new _FeedItemState();
}

class _FeedItemState extends State<FeedItem> {
  String _heading = '';
  int _voteCount = 0;
  int _votestatus = 0;
  bool _isSwiped;

  _FeedItemState() {
    // TODO Perform logic for setting intial values for heading and votecount
    this._heading = 'Hello';
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Row(
        children: <Widget>[
          new _UpvoteWidget(
            voteCount: _voteCount,
            userVoteStatus: _votestatus,
            voteChange: newUserVote,
          ),
          new ThumbnailWidget(
            imageUri: 'https://github.com/flutter/website/blob/master/_includes/code/layout/lakes/images/lake.jpg?raw=true',
          ),
          new Text(_heading),
        ],
      ),
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      height: 100.0,
    );
  }

  void newUserVote(int vote) {
    // TODO Implement remote update logic
    setState(() {
      _votestatus = vote;
    });
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
        height: 70.0,
        width: 70.0,
      ),
      padding: const EdgeInsets.only(
          left: 5.0, right: 5.0),
    );
  }
}

class _UpvoteWidget extends StatelessWidget {
  final int voteCount;
  final int userVoteStatus;

  final ValueChanged<int> voteChange;

  _UpvoteWidget(
      {@required this.voteCount, @required this.userVoteStatus, @required this.voteChange});

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
          child: new Icon(Icons.keyboard_arrow_up,
            color: (userVoteStatus > 0)
                ? LeafColors.upvote_color
                : null,),
          onTap: () => _votePress(1),
        ),
        new Text(voteCount.toString(),
          style: new TextStyle(
            color: (userVoteStatus > 0) ? LeafColors.upvote_color : ((userVoteStatus < 0)
                ? LeafColors.downvote_color
                : null),
          ),
        ),
        new GestureDetector(
          child: new Icon(Icons.keyboard_arrow_down,
            color: (userVoteStatus < 0)
                ? LeafColors.downvote_color
                : null,
          ),
          onTap: () => _votePress(-1),
        ),
      ],
    );
  }
}