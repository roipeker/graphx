import '../../graphx.dart';

class PointerManager<T extends PointerEventData> {
  SystemMouseCursor? get cursor => _cursor;

  set cursor(SystemMouseCursor? val) {
    val ??= SystemMouseCursors.basic;
    if (_cursor == val) return;
    if (_cursor != SystemMouseCursors.none) {
      _lastCursor = _cursor;
    }
    _cursor = val;

    /// TODO: check support.
    SystemChannels.mouseCursor.invokeMethod<void>(
      'activateSystemCursor',
      <String, dynamic>{
        'device': 1,
        'kind': cursor!.kind,
      },
    );
  }

  void setDefaultCursor() {
    cursor = null;
  }

  bool get showingCursor {
    return _cursor != SystemMouseCursors.none;
  }

  set showingCursor(bool val) {
    cursor = val ? _lastCursor : SystemMouseCursors.none;
  }

  SystemMouseCursor? _cursor;
  SystemMouseCursor? _lastCursor;

  EventSignal<T> get onInput => _onInput ??= EventSignal<T>();
  EventSignal<T>? _onInput;

  EventSignal<T> get onDown => _onDown ??= EventSignal<T>();
  EventSignal<T>? _onDown;

  EventSignal<T> get onUp => _onUp ??= EventSignal<T>();
  EventSignal<T>? _onUp;

  EventSignal<T> get onCancel => _onCancel ??= EventSignal<T>();
  EventSignal<T>? _onCancel;

  EventSignal<T> get onMove => _onMove ??= EventSignal<T>();
  EventSignal<T>? _onMove;

  EventSignal<T> get onScroll => _onScroll ??= EventSignal<T>();
  EventSignal<T>? _onScroll;

  EventSignal<T> get onHover => _onHover ??= EventSignal<T>();
  EventSignal<T>? _onHover;

  EventSignal<T> get onExit => _onExit ??= EventSignal<T>();
  EventSignal<T>? _onExit;

  EventSignal<T> get onEnter => _onEnter ??= EventSignal<T>();
  EventSignal<T>? _onEnter;

  PointerEventData? _lastEvent;
  final Map _signalMapper = {};

  PointerManager() {
    _signalMapper[PointerEventType.down] = () => _onDown;
    _signalMapper[PointerEventType.up] = () => _onUp;
    _signalMapper[PointerEventType.cancel] = () => _onCancel;
    _signalMapper[PointerEventType.move] = () => _onMove;
    _signalMapper[PointerEventType.scroll] = () => _onScroll;

    /// mouse
    _signalMapper[PointerEventType.hover] = () => _onHover;
    _signalMapper[PointerEventType.enter] = () => _onEnter;
    _signalMapper[PointerEventType.exit] = () => _onExit;
  }

  bool get isDown => _lastEvent?.rawEvent.down ?? false;

  double get mouseX => _lastEvent?.rawEvent.localPosition.dx ?? 0;

  double get mouseY => _lastEvent?.rawEvent.localPosition.dy ?? 0;

  void $process(PointerEventData event) {
    final signal = _signalMapper[event.type]();
    _lastEvent = event;
    onInput.dispatch(event as T);
    signal?.dispatch(event);
  }

  void dispose() {
    _onDown?.removeAll();
    _onUp?.removeAll();
    _onInput?.removeAll();
    _onCancel?.removeAll();
    _onMove?.removeAll();
    _onScroll?.removeAll();
    _onHover?.removeAll();
    _onExit?.removeAll();
    _onEnter?.removeAll();
    _lastEvent = null;
  }
}
