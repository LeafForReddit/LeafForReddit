import 'package:flutter/material.dart';
import 'package:leaf_for_reddit/ui/action_bar.dart';
import 'package:leaf_for_reddit/ui/bottom_bar.dart';
import 'package:leaf_for_reddit/ui/overlays.dart';
import 'package:leaf_for_reddit/ui/sub_list.dart';
import 'package:leaf_for_reddit/ui/user_profile.dart';
import 'package:leaf_for_reddit/ui/bloc/user_service.dart';

class Home extends StatefulWidget {
  final UserInformationManager _infoManager = UserInformationManager();

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
      floatingActionButton: new ActionBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: new BottomBarWidget(),
    );
  }
}




