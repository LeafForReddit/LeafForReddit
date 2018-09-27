import 'package:flutter/material.dart';

abstract class HideUnhideAnimationMixin<T extends StatefulWidget> extends State<T> {
  Widget get child;

  bool get hidden;

  set hidden(bool hidden);

  AnimationController get controller;

  void transition(bool newState) {
    if (newState != hidden) {
      hidden = newState;
      if (newState) {
        controller.reverse();
      } else {
        controller.forward();
      }
    }
  }
}
