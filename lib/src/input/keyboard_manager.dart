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
  EventSignal<T>? _onRepeat;
  EventSignal<T>? _onDown;
  EventSignal<T>? _onUp;
  bool _lastKeyboardEventHandled = false;

  /// Returns whether the alt key is currently pressed.
  bool get isAltPressed {
    return hardwareKeyboard.isAltPressed;
  }

  /// Returns whether the control key is currently pressed.
  bool get isControlPressed {
    return hardwareKeyboard.isControlPressed;
  }

  /// Returns whether the meta key is currently pressed.
  /// On macos, this is the command key.
  /// On windows, this is the windows key.
  bool get isMetaPressed {
    return hardwareKeyboard.isMetaPressed;
  }

  /// Returns whether the shift key is currently pressed.
  bool get isShiftPressed {
    return hardwareKeyboard.isShiftPressed;
  }

  /// The onDown event signal is dispatched when a keystroke is pressed.
  EventSignal<T> get onDown => _onDown ??= EventSignal<T>();

  /// The onUp event signal is dispatched when a keystroke is released.
  EventSignal<T> get onUp => _onUp ??= EventSignal<T>();

  /// The onRepeat event signal is dispatched when a keystroke is held.
  EventSignal<T> get onRepeat => _onRepeat ??= EventSignal<T>();

  /// (Internal usage)
  /// Processes the given [event], returns if the keyboard has handled (true
  /// by default).
  bool $process(KeyboardEventData event) {
    // trace("TYPE: ${event.type}");
    if (event.type == KeyEventType.down) {
      _onDown?.dispatch(event as T);
    } else if (event.type == KeyEventType.repeat) {
      _onRepeat?.dispatch(event as T);
    } else {
      _onUp?.dispatch(event as T);
    }
    return _lastKeyboardEventHandled;
  }


  /// During a keyboard event signal, you can flag if the keyboard has handled
  /// by this widget or not.
  void setKeyboardEventHandled(bool flag) {
    _lastKeyboardEventHandled = flag;
  }

  /// Resolve in code if the widget has Focus, if we only need to take
  /// keyboard action on a small portion of the screen.
  bool get hasKeyboardFocus {
    return focusNode.hasFocus;
  }

  /// Removes all event listeners.
  void dispose() {
    _onRepeat?.removeAll();
    _onDown?.removeAll();
    _onUp?.removeAll();
  }

  /// Direct access to the Hardware Keyboard singleton.
  HardwareKeyboard get hardwareKeyboard => HardwareKeyboard.instance;

  /// Returns whether the given [key] is currently pressed.
  bool isPressed(GKey key) {
    return hardwareKeyboard.isLogicalKeyPressed(key);
  }
}
