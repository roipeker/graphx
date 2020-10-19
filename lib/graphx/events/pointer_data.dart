import 'dart:ui';

import 'package:flutter/gestures.dart';

enum PointerEventType { scroll, cancel, move, up, down, enter, exit, hover }

class PointerEventData {
  final double localX;
  final double localY;
  final PointerEventType type;
  final PointerEvent rawEvent;

  PointerEventData({this.type, this.rawEvent})
      : localX = rawEvent.localPosition.dx,
        localY = rawEvent.localPosition.dy;

  Offset get scrollDelta {
    if (rawEvent is PointerScrollEvent) {
      return (rawEvent as PointerScrollEvent).scrollDelta;
    }
    return null;
  }

  Offset get position => rawEvent.localPosition;

  @override
  String toString() {
    return 'PointerEventData{type: $type, localX: $localX, localY: $localY}';
  }
}
