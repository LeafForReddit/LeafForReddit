import 'package:flutter/material.dart';
import 'package:leaf_for_reddit/ui/actionable_interface.dart';
import 'package:leaf_for_reddit/ui/overlays.dart';

class BottomBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            new BottomBarButton(new BottomBarOption(BottomBarOption.Tabs)),
            new BottomBarButton(new BottomBarOption(BottomBarOption.Subs)),
          ],
        ),
      ),
    );
  }
}

class BottomBarOption {
  static const Tabs = 'TABS';
  static const Subs = 'SUBS';

  static const Map<String, IconData> _iconMap = <String, IconData>{
    Tabs: Icons.view_carousel,
    Subs: Icons.list,
  };

  final String label;
  final IconData icon;

  BottomBarOption._internal(this.label, this.icon);

  factory BottomBarOption(String option) {
    return new BottomBarOption._internal(
        option, _iconMap[option]);
  }
}

class BottomBarButton extends StatelessWidget implements Actionable {
  final BottomBarOption option;

  @override
  Widget build(BuildContext context) {
    return new IconButton(
      icon: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Icon(option.icon),
          new Expanded(
            child: new FittedBox(
              child: new Text(option.label),
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
      onPressed: () => action(context: context),
    );
  }

  factory BottomBarButton(BottomBarOption option) {
    BottomBarButton button;
    switch (option.label) {
      case BottomBarOption.Subs:
        button = new _SubListButton(option);
        break;
      default:
        button = new BottomBarButton._(option);
    }

    return button;
  }

  BottomBarButton._(this.option);

  @override
  void action({@required BuildContext context}){
    return null;
  }
}

class _SubListButton extends BottomBarButton {
  _SubListButton(BottomBarOption option) : super._(option);

  @override
  void action({@required BuildContext context}) {
    return BottomSheetTemplate.summonModal(context);
  }
}
