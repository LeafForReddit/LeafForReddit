import 'package:flutter/widgets.dart';

abstract class ScrollDirectionDetectorMixin {
  double _position;
  ScrollDirection _currentScrollState = ScrollDirection.still;
  set scrollState(ScrollDirection direction);

  bool notificationHandler(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      _position = notification.metrics.extentBefore;
      return true;
    } else if (notification is ScrollUpdateNotification) {
      var newPosition = notification.metrics.extentBefore;
      ScrollDirection scrollDirection;
      if (_position > newPosition) {
        scrollDirection = ScrollDirection.up;
      } else {
        scrollDirection = ScrollDirection.down;
      }

      if (scrollDirection != _currentScrollState) {
        _currentScrollState = scrollDirection;
        scrollState = _currentScrollState;
      }

      _position = newPosition;
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
