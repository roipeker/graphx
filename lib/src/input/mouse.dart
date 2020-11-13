import 'package:flutter/rendering.dart';

import '../../graphx.dart';

export 'package:flutter/rendering.dart' show SystemMouseCursor;

/// also accessible from `pointer_manager.dart`
abstract class GMouse {
  static SystemMouseCursor _cursor;
  static SystemMouseCursor _lastCursor;

  static SystemMouseCursor get cursor => _cursor;

  static set cursor(SystemMouseCursor value) {
    value ??= SystemMouseCursors.basic;
    if (_cursor == value) return;
    if (_cursor != SystemMouseCursors.none) {
      _lastCursor = _cursor;
    }
    _cursor = value;
    SystemChannels.mouseCursor.invokeMethod<void>(
      'activateSystemCursor',
      <String, dynamic>{
        'device': 1,
        'kind': cursor.kind,
      },
    );
  }

  static bool isShowing() => _cursor != SystemMouseCursors.none;

  static void hide() => cursor = SystemMouseCursors.none;

  static void show() => cursor = _lastCursor;
}
