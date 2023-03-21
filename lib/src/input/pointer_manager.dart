import '../../graphx.dart';

/// The PointerManager class is responsible for processing and dispatching
/// pointer events to registered listeners. It supports a wide range of pointer
/// events, including input, down, up, cancel, move, scroll, zoomPan, hover,
/// enter, and exit events. Additionally, it provides access to information
/// about the most recent pointer event, such as the pointer's position and
/// whether the pointer is currently down.
///
/// Is used internally by GraphX to deal with the pointer events.
class PointerManager<T extends PointerEventData> {
  SystemMouseCursor? _cursor;
  SystemMouseCursor? _lastCursor;
  EventSignal<T>? _onInput;
  EventSignal<T>? _onDown;
  EventSignal<T>? _onUp;
  EventSignal<T>? _onCancel;
  EventSignal<T>? _onMove;
  EventSignal<T>? _onScroll;
  EventSignal<T>? _onZoomPan;
  EventSignal<T>? _onHover;
  EventSignal<T>? _onExit;
  EventSignal<T>? _onEnter;
  PointerEventData? _lastEvent;

  /// Maps [PointerEventType]s to the corresponding event signals.
  final Map _signalMapper = {};

  /// Creates a new [PointerManager] instance.
  PointerManager() {
    _signalMapper[PointerEventType.down] = () => _onDown;
    _signalMapper[PointerEventType.up] = () => _onUp;
    _signalMapper[PointerEventType.cancel] = () => _onCancel;
    _signalMapper[PointerEventType.move] = () => _onMove;
    _signalMapper[PointerEventType.scroll] = () => _onScroll;
    _signalMapper[PointerEventType.zoomPan] = () => _onZoomPan;

    /// Mouse code.
    _signalMapper[PointerEventType.hover] = () => _onHover;
    _signalMapper[PointerEventType.enter] = () => _onEnter;
    _signalMapper[PointerEventType.exit] = () => _onExit;
  }

  /// Returns the current system mouse cursor.
  SystemMouseCursor? get cursor {
    return _cursor;
  }

  /// Sets the current system mouse cursor.
  /// If a cursor is set, it will be used until it is changed to a different cursor
  /// or set to `SystemMouseCursors.none`, which will hide the cursor.
  ///
  /// If no cursor is set, the system's default cursor will be used.
  set cursor(SystemMouseCursor? systemCursor) {
    systemCursor ??= SystemMouseCursors.basic;
    if (_cursor == systemCursor) return;
    if (_cursor != SystemMouseCursors.none) {
      _lastCursor = _cursor;
    }
    _cursor = systemCursor;

    /// TODO: check support.
    SystemChannels.mouseCursor.invokeMethod<void>(
      'activateSystemCursor',
      <String, dynamic>{
        'device': 1,
        'kind': cursor!.kind,
      },
    );
  }

  /// Returns whether a pointer is currently down or not.
  /// Returns true if the pointer is currently down (i.e., the user is
  /// currently touching the screen or has pressed the mouse button), otherwise
  /// returns false.
  bool get isDown {
    return _lastEvent?.rawEvent.down ?? false;
  }

  /// Returns the last [PointerEvent] that was processed by [PointerManager]. If
  /// no events have been processed yet, null is returned.
  PointerEvent? get lastEvent {
    return _lastEvent?.rawEvent;
  }

  /// Returns the current X coordinate of the pointer event in local coordinates
  /// relative to the widget that received the event. In the case of GraphX this
  /// represents the Stage's coordinates. Returns 0 if no event has been
  /// received.
  double get mouseX {
    return _lastEvent?.rawEvent.localPosition.dx ?? 0;
  }

  /// Returns the current Y coordinate of the pointer event in local coordinates
  /// relative to the widget that received the event. In the case of GraphX this
  /// represents the Stage's coordinates. Returns 0 if no event has been
  /// received.
  double get mouseY {
    return _lastEvent?.rawEvent.localPosition.dy ?? 0;
  }

  /// The signal for PointerEventData of type [PointerEventType.cancel].
  EventSignal<T> get onCancel => _onCancel ??= EventSignal<T>();

  /// The signal for PointerEventData of type [PointerEventType.down].
  EventSignal<T> get onDown => _onDown ??= EventSignal<T>();

  /// The signal for PointerEventData of type [PointerEventType.enter].
  EventSignal<T> get onEnter => _onEnter ??= EventSignal<T>();

  /// The signal for PointerEventData of type [PointerEventType.exit].
  EventSignal<T> get onExit => _onExit ??= EventSignal<T>();

  /// The signal for PointerEventData of type [PointerEventType.hover].
  EventSignal<T> get onHover => _onHover ??= EventSignal<T>();

  /// Dispatched when any pointer event is detected.
  EventSignal<T> get onInput => _onInput ??= EventSignal<T>();

  /// The signal for PointerEventData of type [PointerEventType.move].
  EventSignal<T> get onMove => _onMove ??= EventSignal<T>();

  /// The signal for PointerEventData of type [PointerEventType.scroll].
  EventSignal<T> get onScroll => _onScroll ??= EventSignal<T>();

  /// The signal for PointerEventData of type [PointerEventType.up].
  EventSignal<T> get onUp => _onUp ??= EventSignal<T>();

  /// The signal for PointerEventData of type [PointerEventType.zoomPan].
  EventSignal<T> get onZoomPan => _onZoomPan ??= EventSignal<T>();

  /// Determines whether the pointer cursor is currently being displayed or not.
  bool get showingCursor {
    return _cursor != SystemMouseCursors.none;
  }

  /// When set to `true`, it shows the cursor, and when set to `false`, it hides
  /// the cursor. The cursor is automatically restored to the last cursor type
  /// when re-shown after being hidden.
  set showingCursor(bool val) {
    cursor = val ? _lastCursor : SystemMouseCursors.none;
  }

  /// (Internal usage)
  ///
  /// Processes the given [event], dispatching it to the appropriate signal
  /// based on its [PointerEventType].
  ///
  /// Additionally, also updates the [_lastEvent] property to hold a reference
  /// to the [event] for later use.
  void $process(PointerEventData event) {
    final signal = _signalMapper[event.type]();
    _lastEvent = event;
    onInput.dispatch(event as T);
    signal?.dispatch(event);
  }

  /// Disposes all the event signals and sets the last event to null.
  void dispose() {
    _onDown?.removeAll();
    _onUp?.removeAll();
    _onInput?.removeAll();
    _onCancel?.removeAll();
    _onMove?.removeAll();
    _onScroll?.removeAll();
    _onZoomPan?.removeAll();
    _onHover?.removeAll();
    _onExit?.removeAll();
    _onEnter?.removeAll();
    _lastEvent = null;
  }

  /// Resets the cursor to the default (usually an arrow cursor).
  void setDefaultCursor() {
    cursor = null;
  }
}
