import 'package:flutter/material.dart';
import 'package:leaf_for_reddit/ui/components/feed.dart';

class PostPageWidget extends StatelessWidget {
  final PostPageBloc _bloc;

  PostPageWidget(this._bloc);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(_bloc.title),
      ),
      body: new Container(),
    );
  }
}

class PostPageBloc {
  FeedItemBloc _feedItemBloc;

  PostPageBloc();

  void next(FeedItemBloc feedItemBloc) {
    _feedItemBloc = feedItemBloc;
  }

  String get title => _feedItemBloc.title ?? '';
}
