import 'package:flutter/services.dart';

enum KeyEventType { down, up }

typedef GKey = LogicalKeyboardKey;

class KeyboardEventData {
  final KeyEventType type;
  final RawKeyEvent rawEvent;

  KeyboardEventData({required this.type, required this.rawEvent});

  bool isPressed(GKey key) => rawEvent.isKeyPressed(key);

  // Returns true if the [GKey] (LogicalKeyboardKey) matches.
  bool isKey(GKey key) => rawEvent.logicalKey == key;

  // Returns true if any matches a LogicalKeyboardKey from the Iterable.
  bool any(Iterable<GKey> list) => list.contains(rawEvent.logicalKey);

  @override
  String toString() {
    return 'KeyboardEventData#$type - ${rawEvent.logicalKey}';
  }
}

extension MyKeyEventExt on KeyboardEventData {
  bool get arrowLeft => rawEvent.logicalKey == GKey.arrowLeft;

  bool get arrowRight => rawEvent.logicalKey == GKey.arrowRight;

  bool get arrowUp => rawEvent.logicalKey == GKey.arrowUp;

  bool get arrowDown => rawEvent.logicalKey == GKey.arrowDown;
}
