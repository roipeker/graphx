import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../graphx/events/keyboard_data.dart';
import '../../graphx/events/signal.dart';

class KeyboardManager<T extends KeyboardEventData> {
  FocusNode focusNode = FocusNode();

  dispose() {
    focusNode?.dispose();
  }

  EventSignal<T> get onDown => _onDown ??= EventSignal<T>();
  EventSignal<T> _onDown;

  EventSignal<T> get onUp => _onUp ??= EventSignal<T>();
  EventSignal<T> _onUp;

  KeyboardEventData _lastEvent;

  bool isPressed(LogicalKeyboardKey key) {
    return _lastEvent?.rawEvent?.isKeyPressed(key) ?? false;
  }

  bool get isShiftPressed => _lastEvent?.rawEvent?.isShiftPressed ?? false;

  bool get isAltPressed => _lastEvent?.rawEvent?.isAltPressed ?? false;

  bool get isControlPressed => _lastEvent?.rawEvent?.isControlPressed ?? false;

  bool get isMetaPressed => _lastEvent?.rawEvent?.isMetaPressed ?? false;

  void $process(KeyboardEventData event) {
    _lastEvent = event;
    if (event.type == KeyEventType.down) {
      _onDown?.dispatch(event);
    } else {
      _onUp?.dispatch(event);
    }
  }
}
