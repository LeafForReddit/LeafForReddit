import 'package:flutter/material.dart';

import 'sub_list.dart';
import 'user_profile.dart';

import 'user_services.dart';

class Home extends StatefulWidget {
  final UserInformationManager _infoManager = null;

  // TODO Add dependency on _infoManager once inpplementation is done
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  String title = 'Leaf';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.account_circle, color: Colors.white,),
            onPressed: () =>
                _summonModal(child: new UserOptionsWidget(widget._infoManager)),
          ),
        ],
      ),
      body: new Center(
        child: new SubList(),
      ),
      floatingActionButton: new _ActionBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _bottomBar(),
    );
  }

  void _summonModal({Widget child}) {
    showModalBottomSheet(context: context, builder: (BuildContext context) {
      return new _BottomSheetTemplate(child: child,);
    });
  }

  BottomAppBar _bottomBar() {
    Widget itemFactory(String label, IconData icon) {
      return new IconButton(
        icon: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Icon(icon),
            new Expanded(
              child: new FittedBox(
                child: new Text(label),
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
        onPressed: _summonModal,
      );
    }

    return new BottomAppBar(
      hasNotch: false,
      child: new Container(
        color: Colors.white,
        height: 56.0,
        alignment: Alignment.center,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            itemFactory('TABS', Icons.view_carousel),
            itemFactory('SUBS', Icons.list),
          ],
        ),
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget barItemBuilder(IconData icon) {
      return new IconButton(
        icon: new Icon(icon, color: Colors.white,),
        onPressed: null,
      );
    }

    return new RaisedButton(
      elevation: 6.0,
      onPressed: null,
      child: new Container(
        height: 40.0,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            barItemBuilder(Icons.clear_all),
            barItemBuilder(Icons.refresh),
            barItemBuilder(Icons.clear_all),
          ],
        ),
      ),
      shape: const StadiumBorder(),
      disabledColor: Colors.green,
    );
  }
}

class _BottomSheetTemplate extends StatelessWidget {
  final Widget child;

  _BottomSheetTemplate({this.child});

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: child,
    );
  }
}
