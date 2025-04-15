import '../../graphx.dart';

/// This class provides utility methods to work with keyboard events.
class GKeyboard {
  /// [GKey] instances to track keys that were just released.
  static final Map<GKey, bool> _justReleased = {};

  /// [GKey] instances to track currently pressed keys.
  static final Map<GKey, bool> _pressed = {};

  /// [GKey] instances to check if any of the corresponding meta keys are down.
  static final Map<GKey, bool Function()> _metaKeys = {
    GKey.shift: () => isDown(GKey.shiftLeft) || isDown(GKey.shiftRight),
    GKey.meta: () => isDown(GKey.metaLeft) || isDown(GKey.metaRight),
    GKey.control: () => isDown(GKey.controlLeft) || isDown(GKey.controlRight),
    GKey.alt: () => isDown(GKey.altLeft) || isDown(GKey.altRight),
  };

  /// The current [Stage] instance to listen for keyboard events.
  static Stage? _stage;

  /// Factory constructor to ensure exception. Throws an exception if an attempt
  /// is made to instantiate this class.
  factory GKeyboard() {
    throw UnsupportedError(
      "Cannot instantiate GKeyboard. Use only static methods.",
    );
  }

  // Private constructor to prevent instantiation
  //GKeyboard._();

  /// Returns `true` if any of the specified [GKey] instances are currently
  /// pressed.
  ///
  /// This method checks both regular keys and meta keys, and returns `true` if
  /// any of them are currently down.
  static bool anyDown(Iterable<GKey> keys) {
    for (final key in keys) {
      if (_metaKeys.containsKey(key)) {
        return _metaKeys[key]!();
      }
      if (_pressed.containsKey(key)) {
        return true;
      }
    }
    return false;
  }

  /// Disposes of the [GKeyboard] utility class.
  ///
  /// This method removes the keyboard event listeners from the current [Stage].
  static void dispose() {
    _stage?.keyboard.onDown.remove(_onKey);
    _stage?.keyboard.onUp.remove(_onKey);
  }

  /// Initializes the [GKeyboard] utility class.
  ///
  /// This method sets up listeners for keyboard events on the specified
  /// [Stage].
  static void init(Stage stage) {
    _stage = stage;
    _stage!.keyboard.onDown.add(_onKey);
    _stage!.keyboard.onUp.add(_onKey);
  }

  /// Returns `true` if the specified [GKey] instance is currently pressed.
  ///
  /// This method checks both regular keys and meta keys.
  static bool isDown(GKey key) {
    if (_metaKeys.containsKey(key)) {
      return _metaKeys[key]!();
    }
    return _pressed[key] ?? false;
  }

  /// Checks if a key has been released and returns a boolean value.
  static bool justReleased(GKey key) {
    var wasDown = _justReleased[key] != null;
    _justReleased.remove(key);
    return wasDown;
  }

  /// The callback function that is called when a key is pressed or released.
  static void _onKey(KeyboardEventData input) {
    final k = input.rawEvent.logicalKey;
    if (input.type == KeyEventType.down) {
      _pressed[k] = true;
    } else {
      _justReleased[k] = true;
      _pressed.remove(k);
    }
  }
}
