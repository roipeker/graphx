import 'dart:ui';

import 'package:flutter/gestures.dart';

import '../../graphx.dart';

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

  GxPoint get windowPosition => GxPoint.fromNative(rawEvent.original.position);
  GxPoint get stagePosition => GxPoint.fromNative(rawEvent.localPosition);
//  Offset get position => rawEvent.localPosition;

  @override
  String toString() {
    return 'PointerEventData{type: $type, localX: $localX, localY: $localY}';
  }

  /// new properties.
  /// TODO: decide how to name mouse/pointer events.
  IAnimatable target;
  IAnimatable dispatcher;
  bool captured = false;
  bool mouseOut = false;

  PointerEventData clone(
    IAnimatable target,
    IAnimatable dispatcher,
    PointerEventType type,
  ) {
    var i = PointerEventData(type: type, rawEvent: rawEvent);
    i.target = target;
    i.dispatcher = dispatcher;
    i.captured = captured;
    return i;
  }
}
