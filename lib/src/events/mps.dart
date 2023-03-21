// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'callback_params.dart';

/// WARNING:
/// If possible, avoid the usage of this class as it's unstable with the
/// Widget tree. Needs revision.

/// MPS is a simple pub/sub system for Dart, similar to an event bus.
final mps = MPS();

/// A publish-subscribe event system that allows communication between different
/// parts of an application.
///
/// This class provides a mechanism for registering callbacks (subscribing) to
/// named events, and triggering those callbacks (publishing) when the named
/// event is emitted. Callbacks can be registered to listen for the named event
/// indefinitely, or just once. The system can also keep track of the number of
/// callbacks registered for each event.

/// Concept taken from the JS library.
/// it has duplicated implemntation between
/// - subscribe = on
/// - unsubscribe = off
/// - publish = emit
/// - publish(N) = emit(N)
/// Accepts a "once()" event like signals.
class MPS {
  final _cache = <String, List<Function?>>{};
  final _cacheOnce = <String, List<Function>>{};

  /// Get the number of subscriptions for a [topic] in the event system.
  int count(String topic) {
    return _cache[topic]?.length ?? 0;
  }

  /// Get the number of one-time subscriptions for a [topic] in the event
  /// system.
  int countOnce(String topic) {
    return _cacheOnce[topic]?.length ?? 0;
  }

  /// Emits a signal to all subscribed functions for a [topic] in the event
  /// system. This method calls all functions subscribed to the topic with no
  /// arguments. Any errors thrown by the functions are silently ignored.
  MPS emit(String topic) {
    void _send(Function? fn) => fn!.call();
    _cache[topic]?.forEach(_send);
    _cacheOnce[topic]?.forEach(_send);
    _cacheOnce.remove(topic);
    return this;
  }

  /// Emits a signal to all subscribed functions for a [topic] in the event
  /// system. This method calls all functions subscribed to the topic with one
  /// argument [arg1]. Any errors thrown by the functions are silently ignored.
  void emit1<T>(String topic, T arg1) {
    void _send(Function? fn) => fn!.call(arg1);
    _cache[topic]?.forEach(_send);
    _cacheOnce[topic]?.forEach(_send);
    _cacheOnce.remove(topic);
  }

  /// Emits a signal to all subscribed functions for a [topic] in the event
  /// system. This method calls all functions subscribed to the topic with two
  /// arguments. Any errors thrown by the functions are silently ignored.
  void emit2<T, S>(String topic, T arg1, S arg2) {
    void _send(Function? fn) => fn!.call(arg1, arg2);
    _cache[topic]?.forEach(_send);
    _cacheOnce[topic]?.forEach(_send);
    _cacheOnce.remove(topic);
  }

  /// Emits a signal to all subscribed functions for a [topic] in the event
  /// system. This method calls all functions subscribed to the topic with three
  /// arguments. Any errors thrown by the functions are silently ignored.
  void emit3<A, B, C>(String topic, A arg1, B arg2, C arg3) {
    void _send(Function? fn) => fn!.call(arg1, arg2, arg3);
    _cache[topic]?.forEach(_send);
    _cacheOnce[topic]?.forEach(_send);
    _cacheOnce.remove(topic);
  }

  /// Emits an event with the given [topic] and [args] to all subscribed
  /// callbacks.
  ///
  /// This method retrieves the list of callbacks subscribed to the given
  /// [topic], then calls each callback with the given [args] using the
  /// [Function.apply] method.
  ///
  /// Additionally, this method retrieves the list of callbacks that were
  /// subscribed once to the given [topic], calls each callback with the given
  /// [args], and then removes them from the list of once-subscribed callbacks.
  ///
  /// If no callbacks are found for the given [topic], this method does nothing.
  void emitParams(String topic, CallbackParams args) {
    void _send(Function? fn) =>
        Function.apply(fn!, args.positional, args.named);
    _cache[topic]?.forEach(_send);
    _cacheOnce[topic]?.forEach(_send);
    _cacheOnce.remove(topic);
  }

  /// Remove a specific [callback] from a [topic]'s subscription list in the
  /// event system. If the function is in the list, removes it from the
  /// subscription and one-time subscription lists.
  void off(String topic, Function? callback) {
    _cache[topic]?.remove(callback);
    _cacheOnce[topic]?.remove(callback);
  }

  /// Removes all callbacks subscribed to the given [event].
  ///
  /// This method removes the list of callbacks subscribed to the given [event]
  /// from the cache, and returns `true` if the event was found and removed. If
  /// no callbacks are found for the given [event], this method returns `false`.
  bool offAll(String event) => _cache.remove(event) != null;

  /// Subscribe a function to a [topic] in the event system. If the [callback]
  /// is not already subscribed, adds it to the subscription list. Returns true
  /// if the function was added to the list, false if it was already subscribed.
  MPS on(String topic, Function? callback) {
    if (!_cache.containsKey(topic)) {
      _cache[topic] = [];
    }
    if (!_cache[topic]!.contains(callback)) {
      _cache[topic]!.add(callback);
    }
    return this;
  }

  /// Registers a callback to listen for the specified event [topic].
  /// The [callback] will only be called once for this event.
  ///
  /// Returns `true` if the callback was added, `false` if it was already added.
  bool once(String topic, Function callback) {
    if (!_cacheOnce.containsKey(topic)) {
      _cacheOnce[topic] = [];
    }
    if (!_cacheOnce[topic]!.contains(callback)) {
      _cacheOnce[topic]!.add(callback);
      return true;
    }
    return false;
  }

  /// Publishes the specified event [topic] to all registered callbacks for
  /// that event without any arguments.
  void publish(String topic) {
    void _send(Function? fn) => fn!.call();
    _cache[topic]?.forEach(_send);
    _cacheOnce[topic]?.forEach(_send);
    _cacheOnce.remove(topic);
  }

  /// Publishes the specified event [topic] along with the given [arg1]
  /// (argument) to all registered callbacks for that event.
  void publish1<T>(String topic, T arg1) {
    void _send(Function? fn) => fn!.call(arg1);
    _cache[topic]?.forEach(_send);
    _cacheOnce[topic]?.forEach(_send);
    _cacheOnce.remove(topic);
  }

  /// Publishes the specified event [topic] along with the given arguments
  /// [arg1] and [arg2] to all registered callbacks for that event.
  void publish2<T, S>(String topic, T arg1, S arg2) {
    void _send(Function? fn) => fn!.call(arg1, arg2);
    _cache[topic]?.forEach(_send);
    _cacheOnce[topic]?.forEach(_send);
    _cacheOnce.remove(topic);
  }

  /// Publishes the specified [topic] along with the given [CallbackParams] to
  /// all registered callbacks for that [topic].
  ///
  /// The [CallbackParams] provide positional and named arguments to pass to the
  /// callbacks.
  void publishParams(String topic, CallbackParams args) {
    void _send(Function? fn) =>
        Function.apply(fn!, args.positional, args.named);
    _cache[topic]?.forEach(_send);
    _cacheOnce[topic]?.forEach(_send);
    _cacheOnce.remove(topic);
  }

  /// Registers a [callback] to listen for the specified event [topic].
  ///
  /// Returns `true` if the callback was added, `false` if it was already added.
  bool subscribe(String topic, Function callback) {
    if (!_cache.containsKey(topic)) {
      _cache[topic] = [];
    }
    if (!_cache[topic]!.contains(callback)) {
      _cache[topic]!.add(callback);
      return true;
    }
    return false;
  }

  @override
  String toString() {
    return 'MPS {'
        '\n  cache: $_cache,'
        '\n  cacheOnce: $_cacheOnce'
        '\n}';
  }

  /// Unregisters the specified [callback] from the specified event [topic].
  ///
  /// Returns `true` if the callback was found and removed, `false` otherwise.
  bool unsubscribe(String topic, Function callback) {
    final subs = _cache[topic]!;
    return subs.remove(callback);
  }
}
