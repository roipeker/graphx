import 'callback_params.dart';

final mps = MPS();

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

  void publishParams(String topic, CallbackParams args) {
    void _send(Function? fn) =>
        Function.apply(fn!, args.positional, args.named);

    _cache[topic]?.forEach(_send);
    _cacheOnce[topic]?.forEach(_send);
    _cacheOnce.remove(topic);
  }

  void publish1<T>(String topic, T arg1) {
//    _cache[topic]?.forEach((fn) => fn.call(arg1));
    void _send(Function? fn) => fn!.call(arg1);
    _cache[topic]?.forEach(_send);
    _cacheOnce[topic]?.forEach(_send);
    _cacheOnce.remove(topic);
  }

  void publish2<T, S>(String topic, T arg1, S arg2) {
//    _cache[topic]?.forEach((fn) => fn.call(arg1, arg2));
    void _send(Function? fn) => fn!.call(arg1, arg2);
    _cache[topic]?.forEach(_send);
    _cacheOnce[topic]?.forEach(_send);
    _cacheOnce.remove(topic);
  }

  void publish(String topic) {
//    _cache[topic]?.forEach((fn) => fn.call());
    void _send(Function? fn) => fn!.call();
    _cache[topic]?.forEach(_send);
    _cacheOnce[topic]?.forEach(_send);
    _cacheOnce.remove(topic);
//    cache[topic]?.forEach((fn) => fn.call());
//    final len = cache[topic].length;
//    for (var i = 0; i < len; ++i) {
////    for (var i = len - 1; i >= 0; --i) {
//      subs[i]?.call();
//    }

//    for (final fn in subs) {
//      fn();
//    }

//    for (var i = 0; i < len; ++i) {
//      subs[i]?.call();
//    }
//    while (len-- > 0) {
//      final fn = subs[len];
//      fn?.call();
//      Function.apply(subs[len], args?.positional);
//    }
  }

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

  bool subscribe(String topic, Function callback) {
    if (!_cache.containsKey(topic)) {
      _cache[topic] = [];
//      cache[topic] = LinkedList();
    }
    if (!_cache[topic]!.contains(callback)) {
//      cache[topic].add(Callback(callback));
      _cache[topic]!.add(callback);
      return true;
    }
    return false;
  }

  bool unsubscribe(String topic, Function callback) {
    final subs = _cache[topic]!;
    return subs.remove(callback);
//    subs.remove(Callback._hash[callback]);
//    int len = subs?.length ?? 0;
//    while (--len > 0) {
//      if (subs[len] == callback) {
//        subs.removeAt(len);
//        return true;
//      }
//    }
//    return false;
  }

  int count(String topic) {
    return _cache[topic]?.length ?? 0;
  }

  int countOnce(String topic) {
    return _cacheOnce[topic]?.length ?? 0;
  }

  void off(String topic, Function? callback) {
    _cache[topic]?.remove(callback);
    _cacheOnce[topic]?.remove(callback);
  }

  MPS emit(String topic) {
    void _send(Function? fn) => fn!.call();
    _cache[topic]?.forEach(_send);
    _cacheOnce[topic]?.forEach(_send);
    _cacheOnce.remove(topic);
    return this;
  }

  MPS on(String topic, Function? callback) {
    if (!_cache.containsKey(topic)) {
      _cache[topic] = [];
    }
    if (!_cache[topic]!.contains(callback)) {
      _cache[topic]!.add(callback);
    }
    return this;
  }

  void emit1<T>(String topic, T arg1) {
    void _send(Function? fn) => fn!.call(arg1);
    _cache[topic]?.forEach(_send);
    _cacheOnce[topic]?.forEach(_send);
    _cacheOnce.remove(topic);
  }

  void emit2<T, S>(String topic, T arg1, S arg2) {
    void _send(Function? fn) => fn!.call(arg1, arg2);
    _cache[topic]?.forEach(_send);
    _cacheOnce[topic]?.forEach(_send);
    _cacheOnce.remove(topic);
  }

  void emit3<A, B, C>(String topic, A arg1, B arg2, C arg3) {
    void _send(Function? fn) => fn!.call(arg1, arg2, arg3);
    _cache[topic]?.forEach(_send);
    _cacheOnce[topic]?.forEach(_send);
    _cacheOnce.remove(topic);
  }

  void emitParams(String topic, CallbackParams args) {
    void _send(Function? fn) =>
        Function.apply(fn!, args.positional, args.named);
    _cache[topic]?.forEach(_send);
    _cacheOnce[topic]?.forEach(_send);
    _cacheOnce.remove(topic);
  }

  bool offAll(String event) => _cache.remove(event) != null;
}

// Removed the type reference "variable", in favor of duplicated implementation.
//typedef _Emitter = void Function(String topic);
//typedef _Subscriber = bool Function(String topic, Function callback);
