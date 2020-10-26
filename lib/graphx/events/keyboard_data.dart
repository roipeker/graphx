import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

enum KeyEventType { down, up }

class KeyboardEventData {
  final KeyEventType type;
  final RawKeyEvent rawEvent;

  KeyboardEventData({this.type, this.rawEvent});

  bool isPress(LogicalKeyboardKey key) {
    return rawEvent.isKeyPressed(key);
  }

  bool hasKey(LogicalKeyboardKey key) {
    return rawEvent.logicalKey == key;
  }
}

extension MyKeyEventExt on KeyboardEventData {
  bool get arrowLeft {
//    return rawEvent.isKeyPressed(LogicalKeyboardKey.arrowLeft);
    return rawEvent.logicalKey == LogicalKeyboardKey.arrowLeft;
  }

  bool get arrowRight {
    return rawEvent.logicalKey == LogicalKeyboardKey.arrowRight;
//    return rawEvent.isKeyPressed(LogicalKeyboardKey.arrowRight);
  }

  bool get arrowUp {
    return rawEvent.isKeyPressed(LogicalKeyboardKey.arrowUp);
  }

  bool get arrowDown {
    return rawEvent.isKeyPressed(LogicalKeyboardKey.arrowDown);
  }
}
