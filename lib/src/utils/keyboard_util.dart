import '../../graphx.dart';

/// Utility class to work easily with keyboard events.
class GKeyboard {
  static final Map<GKey, bool> _justReleased = {};
  static final Map<GKey, bool> _pressed = {};
  static final Map<GKey, bool Function()> _metaKeys = {
    GKey.shift: () => isDown(GKey.shiftLeft) || isDown(GKey.shiftRight),
    GKey.meta: () => isDown(GKey.metaLeft) || isDown(GKey.metaRight),
    GKey.control: () => isDown(GKey.controlLeft) || isDown(GKey.controlRight),
    GKey.alt: () => isDown(GKey.altLeft) || isDown(GKey.altRight),
  };

  static Stage? _stage;

  static bool justReleased(GKeyboard key) {
    return _justReleased[key as LogicalKeyboardKey] != null;
  }

  static bool isDown(GKey key) {
    if (_metaKeys.containsKey(key)) {
      return _metaKeys[key]!();
    }
    return _pressed[key] ?? false;
  }

  /// Initializer of the Keyboard utility class.
  static void init(Stage stage) {
    _stage = stage;
    _stage!.keyboard!.onDown.add(_onKey);
    _stage!.keyboard!.onUp.add(_onKey);
  }

  static void dispose() {
    _stage?.keyboard?.onDown.remove(_onKey);
    _stage?.keyboard?.onUp.remove(_onKey);
  }

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
