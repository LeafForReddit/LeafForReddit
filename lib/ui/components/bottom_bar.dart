import 'dart:async';

import 'package:flutter/material.dart';
import 'package:leaf_for_reddit/ui/actionable_interface.dart';
import 'package:leaf_for_reddit/ui/components/animated_mixin.dart';
import 'package:leaf_for_reddit/ui/components/overlays.dart';
import 'package:rxdart/subjects.dart';

class AnimatedBottomAppBar extends StatefulWidget {
  final BottomAppBar _child;
  final _hidden = BehaviorSubject<bool>();

  AnimatedBottomAppBar()
      : _child = new BottomAppBar(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new BottomBarButton(new BottomBarOption(BottomBarOption.Tabs)),
              new BottomBarButton(new BottomBarOption(BottomBarOption.Subs)),
            ],
          ),
        );

  @override
  State<StatefulWidget> createState() => new _AnimatedBottomAppBarState();

  Stream<bool> get hiddenStream => _hidden.stream;

  set hidden(bool hidden) => _hidden.add(hidden);
}

class _AnimatedBottomAppBarState extends State<AnimatedBottomAppBar>
    with
        SingleTickerProviderStateMixin,
        HideUnhideAnimationMixin<AnimatedBottomAppBar> {
  static final Animatable<Offset> _positionTween = Tween<Offset>(
    begin: const Offset(0.0, 1.0),
    end: Offset.zero,
  ).chain(CurveTween(curve: Curves.easeInOut));

  @override
  AnimationController controller;

  @override
  Widget get child => widget._child;

  @override
  bool hidden = true;

  _AnimatedBottomAppBarState();

  @override
  void initState() {
    super.initState();
    widget.hiddenStream.listen(transition);
    controller = new AnimationController(
      duration: const Duration(milliseconds: 2400),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new SlideTransition(
      position: _positionTween.animate(controller),
      child: child,
    );
  }
}

class BottomBar extends StatelessWidget {
  final ValueChanged<String> changeTitle;

  BottomBar({this.changeTitle});

  @override
  Widget build(BuildContext context) {
    return new BottomAppBar(
      child: new Container(
        color: Colors.white,
        height: 56.0,
        alignment: Alignment.center,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new BottomBarButton(new BottomBarOption(BottomBarOption.Tabs)),
            new BottomBarButton(
              new BottomBarOption(BottomBarOption.Subs),
              callback: changeTitle,
            ),
          ],
        ),
      ),
    );
  }
}

// TODO Switch to map lookup like actionbar for constructor
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
    return new BottomBarOption._internal(option, _iconMap[option]);
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

  factory BottomBarButton(BottomBarOption option,
      {ValueChanged<String> callback}) {
    BottomBarButton button;
    switch (option.label) {
      case BottomBarOption.Subs:
        button = new _SubListButton(
          option,
          changeTitle: callback,
        );
        break;
      default:
        button = new BottomBarButton._(option);
    }

    return button;
  }

  BottomBarButton._(this.option);

  @override
  void action({@required BuildContext context}) {
    return null;
  }
}

class _SubListButton extends BottomBarButton {
  final ValueChanged<String> changeTitle;

  _SubListButton(BottomBarOption option, {this.changeTitle}) : super._(option);

  @override
  void action({@required BuildContext context}) {
    return BottomSheetTemplate.summonModal(context);
  }
}
