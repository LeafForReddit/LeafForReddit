import 'package:flutter/material.dart';
import 'package:leaf_for_reddit/config/config_manager.dart';
import 'package:leaf_for_reddit/ui/bloc/user_service.dart';

class UserOptionsWidget extends StatelessWidget {
  final UserInformationManager _infoManager;

  UserOptionsWidget(this._infoManager);

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        profileWidget(),
      ],
    );
  }

  Widget profileWidget() {
    return new Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: StreamBuilder<User>(
        stream: _infoManager.currentUser,
        builder: (context, snapshot) => new Card(
              child: new ListTile(
                leading: new Image.network(
                  'https://github.com/flutter/website/blob/master/_includes/code/layout/lakes/images/lake.jpg?raw=true',
                  height: 76.0,
                  width: 76.0,
                ),
                title: Text('u/${(snapshot.data != null)
                ? snapshot.data.username
                : 'XXXX'}'),
                trailing: const Icon(Icons.settings),
              ),
            ),
      ),
    );
  }
}
