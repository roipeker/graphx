import 'dart:collection';
import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../../graphx.dart';
import 'signal.dart';

mixin EventDispatcherMixin implements Listenable {
  final _updaters = HashSet<VoidCallback>();

  void notify() {
    for (final updater in _updaters) {
      updater();
    }
  }

  @override
  void addListener(VoidCallback listener) => _updaters.add(listener);

  @override
  void removeListener(VoidCallback listener) => _updaters.remove(listener);

  void dispose() {
    _updaters.clear();
  }
}

mixin TickerSignalMixin {
  EventSignal<double> $onEnterFrame;

  EventSignal<double> get onEnterFrame =>
      $onEnterFrame ??= EventSignal<double>();

  void $disposeTickerSignals() {
    $onEnterFrame?.removeAll();
    $onEnterFrame = null;
  }
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
  EventSignal<Canvas> $onPrePaint;
  EventSignal<Canvas> $onPostPaint;
//  EventSignal<Canvas> $onPaint;

  EventSignal<Canvas> get onPrePaint => $onPrePaint ??= EventSignal<Canvas>();

  EventSignal<Canvas> get onPostPaint => $onPostPaint ??= EventSignal<Canvas>();

//  EventSignal<Canvas> get onPaint => $onPaint ??= EventSignal<Canvas>();

  void $disposeRenderSignals() {
    $onPrePaint?.removeAll();
    $onPrePaint = null;
    $onPostPaint?.removeAll();
    $onPostPaint = null;
//    $onPaint?.removeAll();
//    $onPaint = null;
  }
}

/// use mouse signal for now.
mixin StageMouseSignalsMixin<T extends MouseInputData> {
  EventSignal<T> $onMouseLeave;
  EventSignal<T> $onMouseEnter;

  EventSignal<T> get onMouseLeave => $onMouseLeave ??= EventSignal();
  EventSignal<T> get onMouseEnter => $onMouseEnter ??= EventSignal();

  void $disposeStagePointerSignals() {
    $onMouseLeave?.removeAll();
    $onMouseLeave = null;
    $onMouseEnter?.removeAll();
    $onMouseEnter = null;
  }
}

/// use mouse signal for now.
mixin MouseSignalsMixin<T extends MouseInputData> {
  EventSignal<T> $onRightMouseDown;
  EventSignal<T> $onMouseDoubleClick;
  EventSignal<T> $onMouseClick;
  EventSignal<T> $onMouseDown;
  EventSignal<T> $onMouseUp;
  EventSignal<T> $onMouseMove;
  EventSignal<T> $onMouseOut;
  EventSignal<T> $onMouseOver;
  EventSignal<T> $onMouseWheel;
  EventSignal<T> $onLongPress;

  EventSignal<T> get onMouseClick => $onMouseClick ??= EventSignal();
  EventSignal<T> get onMouseDoubleClick =>
      $onMouseDoubleClick ??= EventSignal();
  EventSignal<T> get onRightMouseDown => $onRightMouseDown ??= EventSignal();
  EventSignal<T> get onMouseDown => $onMouseDown ??= EventSignal();
  EventSignal<T> get onMouseUp => $onMouseUp ??= EventSignal();
  EventSignal<T> get onMouseMove => $onMouseMove ??= EventSignal();
  EventSignal<T> get onMouseOver => $onMouseOver ??= EventSignal();
  EventSignal<T> get onMouseOut => $onMouseOut ??= EventSignal();
  EventSignal<T> get onMouseScroll => $onMouseWheel ??= EventSignal();

  EventSignal<T> onLongPress([Duration duration =
  const Duration(milliseconds: 600),double distance = 1]) {
    $onLongPress = EventSignal<T>.longPress(duration,distance);
    return $onLongPress;
  }

  void $disposePointerSignals() {
    $onRightMouseDown?.removeAll();
    $onRightMouseDown = null;
    $onMouseClick?.removeAll();
    $onMouseClick = null;
    $onMouseDoubleClick?.removeAll();
    $onMouseDoubleClick = null;
    $onMouseDown?.removeAll();
    $onMouseDown = null;
    $onMouseUp?.removeAll();
    $onMouseUp = null;
    $onMouseMove?.removeAll();
    $onMouseMove = null;
    $onMouseOver?.removeAll();
    $onMouseOver = null;
    $onMouseOut?.removeAll();
    $onMouseOut = null;
    $onMouseWheel?.removeAll();
    $onMouseWheel = null;
    $onLongPress?.removeAll();
    $onLongPress = null;
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
