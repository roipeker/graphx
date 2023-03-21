import 'package:flutter/services.dart';

/// An enumeration for the type of key events, used in [KeyboardEventData].
enum KeyEventType {
  /// Signifies a key down event.
  down,

  /// Signifies a key up event.
  up
}

/// The logical representation of a keyboard key.
typedef GKey = LogicalKeyboardKey;

/// A class representing keyboard event data.
class KeyboardEventData {
  /// The type of the key event.
  final KeyEventType type;

  /// The raw key event.
  final RawKeyEvent rawEvent;

  /// Creates a new instance of [KeyboardEventData] with the specified [type]
  /// and [rawEvent].
  KeyboardEventData({required this.type, required this.rawEvent});

  /// Returns true if the specified [key] is currently pressed, false otherwise.
  bool isPressed(GKey key) => rawEvent.isKeyPressed(key);

  /// Returns true if the [rawEvent]'s [logicalKey] matches the specified [key],
  /// false otherwise.
  bool isKey(GKey key) => rawEvent.logicalKey == key;

  /// Returns true if any [logicalKey] in the [list] matches the [rawEvent]'s
  /// [logicalKey], false otherwise.
  bool any(Iterable<GKey> list) => list.contains(rawEvent.logicalKey);

  /// Returns a string representation of the [KeyboardEventData].
  @override
  String toString() {
    return 'KeyboardEventData {'
        '\n  type: $type,'
        '\n  logicalKey: ${rawEvent.logicalKey}'
        '\n}';
  }
}

/// An extension class for [KeyboardEventData], which adds helper properties for
/// arrow keys.
extension MyKeyEventExt on KeyboardEventData {
  /// Returns true if the event is an arrow left key event.
  bool get arrowLeft => rawEvent.logicalKey == GKey.arrowLeft;

  /// Returns true if the event is an arrow right key event.
  bool get arrowRight => rawEvent.logicalKey == GKey.arrowRight;

  /// Returns true if the event is an arrow up key event.
  bool get arrowUp => rawEvent.logicalKey == GKey.arrowUp;

  /// Returns true if the event is an arrow down key event.
  bool get arrowDown => rawEvent.logicalKey == GKey.arrowDown;
}
