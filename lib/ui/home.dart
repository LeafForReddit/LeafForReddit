import 'package:flutter/material.dart';
import 'package:leaf_for_reddit/ui/bottom_bar.dart';
import 'package:leaf_for_reddit/ui/overlays.dart';
import 'package:leaf_for_reddit/ui/sub_list.dart';
import 'package:leaf_for_reddit/ui/user_profile.dart';
import 'package:leaf_for_reddit/user_services.dart';

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
                BottomSheetTemplate.summonModal(
                    context, child: new UserOptionsWidget(widget._infoManager)),
          ),
        ],
      ),
      body: new Center(
        child: new SubList(),
      ),
      floatingActionButton: new _ActionBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: new BottomBarWidget(),
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


