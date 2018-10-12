import 'package:flutter/widgets.dart';

abstract class ScrollDirectionDetectorMixin {
  double position;
  ScrollDirection _currentScrollState = ScrollDirection.still;
  set scrollState(ScrollDirection direction);

  bool notificationHandler(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      position = notification.metrics.pixels;
      return true;
    } else if (notification is ScrollUpdateNotification) {
      var newPosition = notification.metrics.pixels;
      ScrollDirection scrollDirection;
      if (newPosition > position) {
        scrollDirection = ScrollDirection.down;
      } else {
        scrollDirection = ScrollDirection.up;
      }

      if (scrollDirection != _currentScrollState) {
        _currentScrollState = scrollDirection;
        scrollState = _currentScrollState;
      }

      position = newPosition;
      return true;
    } else if (notification is ScrollEndNotification) {
      _currentScrollState = ScrollDirection.still;
      scrollState = _currentScrollState;
      return true;
    }

    return false;
  }
}

enum ScrollDirection {
  up,
  down,
  still,
}
