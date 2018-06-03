import 'package:flutter/material.dart';
import 'package:leaf_for_reddit/user_services.dart';


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
      child: new Card(
        child: new ListTile(
          leading: new Image.network(
            'https://github.com/flutter/website/blob/master/_includes/code/layout/lakes/images/lake.jpg?raw=true',
            height: 76.0,
            width: 76.0,
          ),
          title: const Text('u/XXXX'),
          trailing: const Icon(Icons.settings),
        ),
      ),
    );
  }
}
