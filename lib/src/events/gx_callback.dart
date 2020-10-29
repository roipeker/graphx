//import 'package:flutter/material.dart';
//
//typedef Signal0 = void Function();
//typedef Signal1<T> = void Function(T);
//typedef Signal2<T, U> = void Function(T, U);
//typedef Signal3<T, U, V> = void Function(T, U, V);
//
//abstract class GxCallback<T> {
//  List<dynamic> _valueClasses;
//  final _listenersOnce = <T>[];
//  final _listeners = <T>[];
//  int _listenerCount = 0;
//  int _iterDispatch;
//  T _iterDispatchCurrent;
//
//  GxCallback([List<dynamic> valueClasses]) {
//    _valueClasses = valueClasses ?? [];
//  }
//
//  bool hasListeners() => _listeners.isNotEmpty || _listenersOnce.isNotEmpty;
//
//  void add(T listener) {
//    if (listener == null ||
//        _listeners.indexOf(listener) > -1 ||
//        _listenersOnce.indexOf(listener) > -1) return;
//    _listeners.add(listener);
//    _listenerCount++;
//  }
//
//  void addUnsafe(T listener) {
//    if (listener == null) return;
//    _listeners.add(listener);
//    _listenerCount++;
//  }
//
//  void addOnce(T listener) {
//    if (listener == null ||
//        _listeners.indexOf(listener) > -1 ||
//        _listenersOnce.indexOf(listener) > -1) return;
//    _listenersOnce.add(listener);
//    _listenerCount++;
//  }
//
//  void remove(T listener) {
//    final index = _listeners.indexOf(listener);
//    if (index > 0) {
//      if (index <= _iterDispatch) _iterDispatch--;
//      _listeners.removeAt(index);
//      _listenerCount--;
//    } else {
//      _listenersOnce.remove(listener);
//    }
//  }
//
//  void removeALl() {
//    _listenerCount = 0;
//    _listeners.clear();
//    _listenersOnce.clear();
//  }
//}
//
//class Signal extends GxCallback<Signal0> {
//  void dispatch() {
//    _iterDispatch = 0;
//    while (_iterDispatch < _listenerCount) {
//      _listeners[_iterDispatch]?.call();
//      _iterDispatch++;
//    }
//    final onceCount = _listenersOnce.length;
//    for (int i = 0; i < onceCount; ++i) {
//      _listenersOnce.removeAt(0)?.call();
//    }
////    _listenersOnce.forEach((e) {
////      e?.call();
////    });
////    _listenersOnce.clear();
//  }
//}
//
//class SignalEvent<T> extends GxCallback<T> {
//
//  void dispatch(T value) {
//    _iterDispatch = 0;
//    while (_iterDispatch < _listenerCount) {
//      _listeners[_iterDispatch]?.call(value);
//      _iterDispatch++;
//    }
//    final onceCount = _listenersOnce.length;
//    for (int i = 0; i < onceCount; ++i) {
//      _listenersOnce.removeAt(0)?.call(value);
//    }
////    _listenersOnce.forEach((e) {
////      e?.call();
////    });
////    _listenersOnce.clear();
//  }
//}
