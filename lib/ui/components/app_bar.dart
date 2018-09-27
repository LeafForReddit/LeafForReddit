import 'dart:async';

import 'package:flutter/material.dart';
import 'package:leaf_for_reddit/ui/components/animated_mixin.dart';
import 'package:rxdart/subjects.dart';

class AnimatedAppBar extends StatefulWidget implements PreferredSizeWidget {
  final AppBar _child;
  final _hidden = BehaviorSubject<bool>();

  AnimatedAppBar(Widget title, List<Widget> actions)
      : _child = new AppBar(
          centerTitle: true,
          title: title,
          actions: actions,
        );

  @override
  State<StatefulWidget> createState() => new _AnimatedAppBarState();

  @override
  Size get preferredSize => _child.preferredSize;

  set hidden(bool hidden) => _hidden.add(hidden);

  Stream<bool> get hiddenStream => _hidden.stream;

  void dispose() {
    _hidden.close();
  }
}

class _AnimatedAppBarState extends State<AnimatedAppBar>
    with
        SingleTickerProviderStateMixin,
        HideUnhideAnimationMixin<AnimatedAppBar> {
  static final Animatable<Offset> _positionTween = Tween<Offset>(
    begin: const Offset(0.0, -1.0),
    end: Offset.zero,
  ).chain(CurveTween(curve: Curves.easeInOut));

  @override
  AnimationController controller;

  @override
  Widget get child => widget._child;

  @override
  bool hidden = true;

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
