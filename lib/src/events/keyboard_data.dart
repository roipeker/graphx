import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

enum KeyEventType { down, up }
typedef GKey = LogicalKeyboardKey;

class KeyboardEventData {
  final KeyEventType type;
  final RawKeyEvent rawEvent;

  KeyboardEventData({required this.type, required this.rawEvent});

  bool isPressed(GKey key) => rawEvent.isKeyPressed(key);

  bool isKey(GKey key) => rawEvent.logicalKey == key;
}

extension MyKeyEventExt on KeyboardEventData {
  bool get arrowLeft => rawEvent.logicalKey == GKey.arrowLeft;

  bool get arrowRight => rawEvent.logicalKey == GKey.arrowRight;

  bool get arrowUp => rawEvent.logicalKey == GKey.arrowUp;

  bool get arrowDown => rawEvent.logicalKey == GKey.arrowDown;
}
