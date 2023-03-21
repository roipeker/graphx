import 'package:flutter/material.dart';

import '../../graphx.dart';

/// A class that manages keyboard input events and provides signals for when a
/// key is pressed or released.
///
/// It tracks the state of the modifier keys (Shift, Control, Alt, and Meta) and
/// provides access to the state of individual keys.
///
/// Use the [KeyboardManager.onDown] and [KeyboardManager.onUp] signals to
/// subscribe to key press and release events respectively.
///
/// Call the [KeyboardManager.dispose] method to release any resources held by
/// the manager.
///
/// Accessible through [Stage.keyboard] only if the [SceneConfig] has
/// [SceneConfig.useKeyboard] set to true.
class KeyboardManager<T extends KeyboardEventData> {
  /// The focus node for keyboard events in the Flutter Widget tree.
  final focusNode = FocusNode(debugLabel: 'graphx_keyboard_manager');

  EventSignal<T>? _onDown;

  EventSignal<T>? _onUp;

  /// The last keyboard event processed.
  KeyboardEventData? _lastEvent;

  /// Returns whether the alt key is currently pressed.
  bool get isAltPressed {
    return _lastEvent?.rawEvent.isAltPressed ?? false;
  }

  /// Returns whether the control key is currently pressed.
  bool get isControlPressed {
    return _lastEvent?.rawEvent.isControlPressed ?? false;
  }

  /// Returns whether the meta key is currently pressed.
  /// On macos, this is the command key.
  /// On windows, this is the windows key.
  bool get isMetaPressed {
    return _lastEvent?.rawEvent.isMetaPressed ?? false;
  }

  /// Returns whether the shift key is currently pressed.
  bool get isShiftPressed {
    return _lastEvent?.rawEvent.isShiftPressed ?? false;
  }

  /// The onDown event signal is dispatched when a keystroke is pressed.
  EventSignal<T> get onDown => _onDown ??= EventSignal<T>();

  /// The onUp event signal is dispatched when a keystroke is released.
  EventSignal<T> get onUp => _onUp ??= EventSignal<T>();

  /// (Internal usage)
  /// Processes the given [event].
  void $process(KeyboardEventData event) {
    _lastEvent = event;
    if (event.type == KeyEventType.down) {
      _onDown?.dispatch(event as T);
    } else {
      _onUp?.dispatch(event as T);
    }
  }

  /// Removes all event listeners.
  void dispose() {
    _onDown?.removeAll();
    _onUp?.removeAll();
  }

  /// Returns whether the given [key] is currently pressed.
  bool isPressed(GKey key) {
    return _lastEvent?.rawEvent.isKeyPressed(key) ?? false;
  }
}
