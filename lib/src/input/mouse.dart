import '../../graphx.dart';

/// "Static" class for managing system mouse cursors.
/// Accessible from `pointer_manager.dart`
abstract class GMouse {
  /// The current system mouse cursor.
  static SystemMouseCursor _cursor = SystemMouseCursors.basic;

  /// The last cursor shown before hiding the cursor.
  static SystemMouseCursor? _lastCursor;

  /// Gets the current system mouse cursor.
  static SystemMouseCursor get cursor {
    return _cursor;
  }

  /// Sets the current [systemCursor] in the system.
  static set cursor(SystemMouseCursor systemCursor) {
    // value ??= SystemMouseCursors.basic;
    if (_cursor == systemCursor) return;
    if (_cursor != SystemMouseCursors.none) {
      _lastCursor = _cursor;
    }
    _cursor = systemCursor;
    SystemChannels.mouseCursor.invokeMethod<void>(
      'activateSystemCursor',
      <String, dynamic>{
        'device': 1,
        'kind': cursor.kind,
      },
    );
  }

  /// Sets the cursor to the basic cursor.
  static void basic() {
    cursor = SystemMouseCursors.basic;
  }

  /// Hides the cursor.
  static void hide() {
    cursor = SystemMouseCursors.none;
  }

  /// Returns whether the cursor is currently showing.
  static bool isShowing() {
    return _cursor != SystemMouseCursors.none;
  }

  /// Sets the cursor to the system click cursor.
  static void setClickCursor() {
    cursor = SystemMouseCursors.click;
  }

  /// Shows the cursor.
  static void show() {
    cursor = (_lastCursor ?? SystemMouseCursors.basic);
  }
}
