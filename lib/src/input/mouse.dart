import '../../graphx.dart';

/// Accessible from `pointer_manager.dart`
abstract class GMouse {
  static SystemMouseCursor _cursor = SystemMouseCursors.basic;
  static SystemMouseCursor? _lastCursor;

  static SystemMouseCursor get cursor => _cursor;

  static void setClickCursor() => cursor = SystemMouseCursors.click;

  static set cursor(SystemMouseCursor value) {
    // value ??= SystemMouseCursors.basic;
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

  static void show() => cursor = (_lastCursor ?? SystemMouseCursors.basic);

  static void basic() => cursor = SystemMouseCursors.basic;
}
