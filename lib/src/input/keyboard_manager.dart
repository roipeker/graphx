import 'package:flutter/material.dart';

import '../../graphx.dart';

class KeyboardManager<T extends KeyboardEventData> {
  final focusNode = FocusNode();

  void dispose() {
    _onDown?.removeAll();
    _onUp?.removeAll();
  }

  EventSignal<T> get onDown => _onDown ??= EventSignal<T>();
  EventSignal<T>? _onDown;

  EventSignal<T> get onUp => _onUp ??= EventSignal<T>();
  EventSignal<T>? _onUp;

  KeyboardEventData? _lastEvent;

  bool isPressed(GKey key) {
    return _lastEvent?.rawEvent.isKeyPressed(key) ?? false;
  }

  bool get isShiftPressed => _lastEvent?.rawEvent.isShiftPressed ?? false;

  bool get isAltPressed => _lastEvent?.rawEvent.isAltPressed ?? false;

  bool get isControlPressed => _lastEvent?.rawEvent.isControlPressed ?? false;

  bool get isMetaPressed => _lastEvent?.rawEvent.isMetaPressed ?? false;

  void $process(KeyboardEventData event) {
    _lastEvent = event;
    if (event.type == KeyEventType.down) {
      _onDown?.dispatch(event as T);
    } else {
      _onUp?.dispatch(event as T);
    }
  }
}
