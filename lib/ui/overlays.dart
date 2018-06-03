import 'package:flutter/material.dart';

class BottomSheetTemplate extends StatelessWidget {
  final Widget child;

  BottomSheetTemplate({this.child});

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: child,
    );
  }

  static void summonModal(BuildContext context, {Widget child}) {
    showModalBottomSheet(context: context, builder: (BuildContext context) {
      return new BottomSheetTemplate(child: child,);
    });
  }
}