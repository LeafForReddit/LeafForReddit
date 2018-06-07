import 'package:flutter/material.dart';
import 'package:leaf_for_reddit/ui/actionable_interface.dart';
import 'package:leaf_for_reddit/ui/overlays.dart';

class ActionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new RaisedButton(
      elevation: 6.0,
      onPressed: null,
      child: new Container(
        height: 40.0,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ActionBarButton(ActionBarOption.clearAll),
            new ActionBarButton(ActionBarOption.refresh),
            new ActionBarButton(ActionBarOption.sidebar),
          ],
        ),
      ),
      shape: const StadiumBorder(),
      disabledColor: Colors.green,
    );
  }
}

abstract class ActionBarOption {
  static const refresh = Icons.refresh;
  static const clearAll = Icons.clear_all;
  static const sidebar = Icons.info_outline;
}

class ActionBarButton extends StatelessWidget implements Actionable {
  final IconData _icon;

  static Map<IconData, Function> _constructorMap = <IconData, Function>{
    ActionBarOption.sidebar : (icon) => _SidebarButton(icon),
  };

  @override
  Widget build(BuildContext context) {
    return new IconButton(
      icon: new Icon(_icon, color: Colors.white,),
      onPressed: () => action(context: context),
    );
  }

  factory ActionBarButton(icon) {
    if (_constructorMap.containsKey(icon)) {
      return _constructorMap[icon](icon);
    } else {
      return new ActionBarButton._(icon);
    }
  }

  ActionBarButton._(this._icon);

  @override
  void action({BuildContext context}) {
    return null;
  }
}

class _SidebarButton extends ActionBarButton {
  _SidebarButton(IconData icon) : super._(icon);

  @override
  void action({BuildContext context}) {
    BottomSheetTemplate.summonModal(context);
  }
}