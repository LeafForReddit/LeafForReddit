import 'package:flutter/material.dart';

import 'sub_list.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Leaf For Reddit',
      theme: new ThemeData(
        primaryColor: Colors.green,
      ),
      home: new Home(title: 'Leaf'),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.account_circle, color: Colors.white,),
            onPressed: null,
          ),
        ],
      ),
      body: new Center(
        child: new SubList(),
      ),
      floatingActionButton: new ActionBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _bottomBar(),
    );
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
        onPressed: () {},
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

class ActionBar extends StatelessWidget {
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

