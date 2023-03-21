/// Signature for a callback that receives an event of type [T].
typedef EventSignalCallback<T> = void Function(T event);

/// A signal that can be dispatched to multiple listeners, with data of type [T].
class EventSignal<T> {
  // List of listeners to be dispatched only once.
  final _listenersOnce = <EventSignalCallback<T>>[];

  // List of listeners to be dispatched every time.
  final _listeners = <EventSignalCallback<T>>[];

  // Current index of dispatched listeners.
  int _iterDispatchers = 0;

  int _iterLen = 0;

  /// Adds [callback] to the list of listeners. If it already exists in the
  /// list, it will not be added again.
  void add(EventSignalCallback<T> callback) {
    if (has(callback)) return;
    _listeners.add(callback);
  }

  /// Adds [callback] to the list of listeners, but only once. It will be
  /// removed from the list after being dispatched once.
  void addOnce(EventSignalCallback<T> callback) {
    if (_listeners.contains(callback)) return;
    _listenersOnce.add(callback);
  }

  /// Convenience method that calls [dispatch] with [data] as argument.
  /// Making the [EventSignal] instance callable.
  /// Example:
  /// ```dart
  ///   final onData = EventSignal<String>();
  ///   onData.add((data) => print(data));
  ///   onData("Hello World"); // dispatches.
  /// ```
  /// Equivalent to calling dispatch(data).
  void call(T data) {
    dispatch(data);
  }

  /// Dispatches the signal to all registered listeners, passing [data] to each
  /// listener.
  void dispatch(T data) {
    _iterLen = _listeners.length;
    for (_iterDispatchers = 0;
        _iterDispatchers < _iterLen;
        ++_iterDispatchers) {
      _listeners[_iterDispatchers].call(data);
    }
    _iterLen = _listenersOnce.length;
    while (_iterLen > 0) {
      _listenersOnce.removeAt(0).call(data);
      _iterLen--;
    }
  }

  /// Returns true if [callback] is currently in the list of listeners.
  bool has(EventSignalCallback<T> callback) {
    return _listeners.contains(callback) || _listenersOnce.contains(callback);
  }

  /// Returns true if the signal has any registered listeners.
  bool hasListeners() => _listeners.isNotEmpty || _listenersOnce.isNotEmpty;

  /// Removes [callback] from the list of listeners.
  void remove(EventSignalCallback<T> callback) {
    final idx = _listeners.indexOf(callback);
    if (idx > -1) {
      if (idx <= _iterDispatchers) {
        _iterDispatchers--;
      }
      --_iterLen;
      _listeners.removeAt(idx);
    } else {
      _listenersOnce.remove(callback);
    }
  }

  /// Removes all listeners from the signal.
  void removeAll() {
    _listeners.clear();
    _listenersOnce.clear();
  }
}

/// A signal that can be dispatched to multiple listeners, without returning any
/// data.
class Signal {
  // List of listeners to be dispatched only once.
  final _listenersOnce = <Function>[];

  // List of listeners to be dispatched every time.
  final _listeners = <Function>[];

  // Current index of dispatched listeners.
  int _iterDispatchers = 0;

  /// Adds [callback] to the list of listeners. If it already exists in the
  /// list, it will not be added again.
  void add(Function callback) {
    if (has(callback)) return;
    _listeners.add(callback);
  }

  /// Adds [callback] to the list of listeners, but only once. It will be
  /// removed from the list after being dispatched once.
  void addOnce(Function callback) {
    if (_listeners.contains(callback)) return;
    _listenersOnce.add(callback);
  }

  /// Dispatches the signal to all registered listeners.
  void dispatch() {
    final len = _listeners.length;
    for (_iterDispatchers = 0; _iterDispatchers < len; ++_iterDispatchers) {
      _listeners[_iterDispatchers].call();
    }
    final lenCount = _listenersOnce.length;
    for (var i = 0; i < lenCount; i++) {
      _listenersOnce.removeAt(0).call();
    }
  }

  /// Dispatches the signal to all registered listeners, passing [data] to each
  /// listener.
  void dispatchWithData(dynamic data) {
    final len = _listeners.length;
    for (_iterDispatchers = 0; _iterDispatchers < len; ++_iterDispatchers) {
      _listeners[_iterDispatchers].call(data);
    }
    final lenCount = _listenersOnce.length;
    for (var i = 0; i < lenCount; i++) {
      _listenersOnce.removeAt(i).call(data);
    }
  }

  /// Returns true if [callback] is currently in the list of listeners.
  bool has(Function callback) {
    return _listeners.contains(callback) || _listenersOnce.contains(callback);
  }

  /// Returns true if the signal has any registered listeners.
  bool hasListeners() => _listeners.isNotEmpty || _listenersOnce.isNotEmpty;

  /// Removes [callback] from the list of listeners.
  void remove(Function callback) {
    final idx = _listeners.indexOf(callback);
    if (idx > -1) {
      if (idx <= _iterDispatchers) _iterDispatchers--;
      _listeners.removeAt(idx);
    } else {
      _listenersOnce.remove(callback);
    }
  }

  /// Removes all listeners from the signal.
  void removeAll() {
    _listeners.clear();
    _listenersOnce.clear();
  }
}
