import 'package:flutter/material.dart';

class AnimatedAppBar extends StatelessWidget implements PreferredSizeWidget {
  static final Animatable<Offset> _positionTween = Tween<Offset>(
  begin: const Offset(0.0, -1.0),
  end: Offset.zero,
  ).chain(CurveTween(curve: Curves.easeInOut));

  final AppBar _child;
  final AnimationController controller;

  AnimatedAppBar(Widget title, List<Widget> actions,
      {this.controller})
      : _child = new AppBar(
          centerTitle: true,
          title: title,
          actions: actions,
        );

  @override
  Widget build(BuildContext context) {
    return (controller != null)
        ? new SlideTransition(
      position: _positionTween.animate(controller),
      child: _child,
    )
        :_child;
  }

  @override
  Size get preferredSize => _child.preferredSize;
}
