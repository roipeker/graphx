import 'dart:collection';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:graphx/graphx/events/pointer_data.dart';
import 'package:graphx/graphx/events/signal_data.dart';

import 'signal.dart';

mixin EventDispatcherMixin implements Listenable {
  final _updaters = HashSet<VoidCallback>();

  void notify() {
    for (final updater in _updaters) updater();
  }

  @override
  void addListener(listener) => _updaters.add(listener);

  @override
  void removeListener(listener) => _updaters.remove(listener);

  void dispose() {
    _updaters.clear();
  }
}

mixin TickerSignalMixin {
  Signal $onEnterFrame;

  Signal get onEnterFrame => $onEnterFrame ??= Signal();

  void $disposeTickerSignals() {
    $onEnterFrame?.removeAll();
    $onEnterFrame = null;
  }
}

mixin JugglerSignalMixin {
  EventSignal<JugglerObjectEventData> $onRemovedFromJuggler;
  EventSignal<JugglerObjectEventData> get onRemovedFromJuggler =>
      $onRemovedFromJuggler ??= EventSignal<JugglerObjectEventData>();
}

mixin ResizeSignalMixin {
  Signal $onResized;
  Signal get onResized => $onResized ??= Signal();

  void $disposeResizeSignals() {
    $onResized?.removeAll();
    $onResized = null;
  }
}

mixin DisplayListSignalsMixin {
  Signal $onAdded;

  Signal get onAdded => $onAdded ??= Signal();

  Signal $onRemoved;

  Signal get onRemoved => $onRemoved ??= Signal();

  Signal $onRemovedFromStage;

  Signal get onRemovedFromStage => $onRemovedFromStage ??= Signal();

  Signal $onAddedToStage;

  Signal get onAddedToStage => $onAddedToStage ??= Signal();

  void $disposeDisplayListSignals() {
    $onAdded?.removeAll();
    $onAdded = null;
    $onRemoved?.removeAll();
    $onRemoved = null;
    $onRemovedFromStage?.removeAll();
    $onRemovedFromStage = null;
    $onAddedToStage?.removeAll();
    $onAddedToStage = null;
  }
}

mixin RenderSignalMixin {
  Signal $onPrePaint;
  Signal $onPostPaint;
  Signal $onPaint;

  Signal get onPrePaint => $onPrePaint ??= Signal();

  Signal get onPostPaint => $onPostPaint ??= Signal();

  Signal get onPaint => $onPaint ??= Signal();

  void $disposeRenderSignals() {
    $onPrePaint?.removeAll();
    $onPrePaint = null;
    $onPostPaint?.removeAll();
    $onPostPaint = null;
    $onPaint?.removeAll();
    $onPaint = null;
  }
}

mixin PointerSignalsMixin<T extends PointerEventData> {
  EventSignal<T> $onClick;
  EventSignal<T> $onDown;
  EventSignal<T> $onUp;
  EventSignal<T> $onHover;
  EventSignal<T> $onOut;
  EventSignal<T> $onScroll;

  EventSignal<T> get onClick => $onClick ??= EventSignal();
  EventSignal<T> get onDown => $onDown ??= EventSignal();
  EventSignal<T> get onUp => $onUp ??= EventSignal();
  EventSignal<T> get onHover => $onHover ??= EventSignal();
  EventSignal<T> get onOut => $onOut ??= EventSignal();
  EventSignal<T> get onScroll => $onScroll ??= EventSignal();

  void $disposePointerSignals() {
    $onClick?.removeAll();
    $onClick = null;
    $onDown?.removeAll();
    $onDown = null;
    $onUp?.removeAll();
    $onUp = null;
    $onHover?.removeAll();
    $onHover = null;
    $onOut?.removeAll();
    $onOut = null;
    $onScroll?.removeAll();
    $onScroll = null;
  }
}
