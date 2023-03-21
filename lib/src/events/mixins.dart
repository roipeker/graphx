import 'dart:collection';
import 'dart:ui';

import '../../graphx.dart';

/// A mixin that provides an [EventDispatcher] with [Listenable] functionality.
///
/// You can notify all registered listeners using the [notify] method.
mixin EventDispatcherMixin implements Listenable {
  final _updaters = HashSet<VoidCallback>();

  /// Notifies all registered listeners.
  void notify() {
    for (final updater in _updaters) {
      updater();
    }
  }

  /// To be comply with [Listenable].
  @override
  void addListener(VoidCallback listener) => _updaters.add(listener);

  /// To be comply with [Listenable].
  @override
  void removeListener(VoidCallback listener) => _updaters.remove(listener);

  /// Removes all registered listeners.
  void dispose() {
    _updaters.clear();
  }
}

/// A mixin that provides a [Ticker] signal for updating the display frame.
mixin TickerSignalMixin {
  /// (Internal)
  EventSignal<double>? $onEnterFrame;

  /// Returns the [EventSignal] that is triggered on every frame update.
  EventSignal<double> get onEnterFrame =>
      $onEnterFrame ??= EventSignal<double>();

  /// (Internal)
  /// Removes all registered listeners and frees the [onEnterFrame] signal.
  void $disposeTickerSignals() {
    $onEnterFrame?.removeAll();
    $onEnterFrame = null;
  }
}

/// A mixin that provides a [Signal] for when the size of an object changes.
mixin ResizeSignalMixin {
  /// (Internal)
  Signal? $onResized;

  /// Returns the [Signal] that is triggered when the size of an object changes.
  Signal get onResized => $onResized ??= Signal();

  /// (Internal)
  /// Removes all registered listeners and frees the [onResized] signal.
  void $disposeResizeSignals() {
    $onResized?.removeAll();
    $onResized = null;
  }
}

/// A mixin that provides signals for objects added or removed from the display
/// list.
mixin DisplayListSignalsMixin {
  /// (Internal)
  Signal? $onAdded;

  /// Returns the [Signal] that is triggered when an object is added to the
  /// display list.
  Signal get onAdded => $onAdded ??= Signal();

  /// (Internal)
  Signal? $onRemoved;

  /// Returns the [Signal] that is triggered when an object is removed from the
  /// display list.
  Signal get onRemoved => $onRemoved ??= Signal();

  /// (Internal)
  Signal? $onRemovedFromStage;

  /// Returns the [Signal] that is triggered when an object is removed from the
  /// stage.
  Signal get onRemovedFromStage => $onRemovedFromStage ??= Signal();

  /// (Internal)
  Signal? $onAddedToStage;

  /// Returns the [Signal] that is triggered when an object is added to the
  /// stage.
  Signal get onAddedToStage => $onAddedToStage ??= Signal();

  /// Removes all registered listeners and frees all display list signals.
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

/// A mixin that provides signals for rendering events.
mixin RenderSignalMixin {
  /// (Internal)
  EventSignal<Canvas>? $onPreTransform;

  /// (Internal)
  EventSignal<Canvas>? $onPrePaint;

  /// (Internal)
  EventSignal<Canvas>? $onPostPaint;

  /// A signal that runs right away when [GDisplayObject.paint] is called,
  /// before any mask or filters are applied. This is the first signal to run
  /// on rendering.
  EventSignal<Canvas> get onPreTransform =>
      $onPreTransform ??= EventSignal<Canvas>();

  /// A signal that runs before [GDisplayObject.$applyPaint], which is the
  /// render method to subclass.
  EventSignal<Canvas> get onPrePaint => $onPrePaint ??= EventSignal<Canvas>();

  /// A signal that runs right after [GDisplayObject.$applyPaint] is called.
  EventSignal<Canvas> get onPostPaint => $onPostPaint ??= EventSignal<Canvas>();

  /// Disposes all render-related signals and clears all callbacks for this
  /// instance. This method should be called when the instance is no longer
  /// needed, to prevent memory leaks.
  void $disposeRenderSignals() {
    $onPreTransform?.removeAll();
    $onPreTransform = null;

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
  /// (Internal)
  EventSignal<T>? $onMouseLeave;

  /// (Internal)
  EventSignal<T>? $onMouseEnter;

  /// A signal that is dispatched when the mouse leaves the stage.
  EventSignal<T> get onMouseLeave => $onMouseLeave ??= EventSignal();

  /// A signal that is dispatched when the mouse enters the stage.
  EventSignal<T> get onMouseEnter => $onMouseEnter ??= EventSignal();

  /// Disposes all stage mouse signals to free up memory.
  void $disposeStagePointerSignals() {
    $onMouseLeave?.removeAll();
    $onMouseLeave = null;
    $onMouseEnter?.removeAll();
    $onMouseEnter = null;
  }
}

/// A mixin that provides mouse-related signals for a component.
///
/// Only use mouse signals for now.
mixin MouseSignalsMixin<T extends MouseInputData> {
  /// (Internal)
  EventSignal<T>? $onRightMouseDown;

  /// (Internal)
  EventSignal<T>? $onMouseDoubleClick;

  /// (Internal)
  EventSignal<T>? $onMouseClick;

  /// (Internal)
  EventSignal<T>? $onMouseDown;

  /// (Internal)
  EventSignal<T>? $onMouseUp;

  /// (Internal)
  EventSignal<T>? $onMouseMove;

  /// (Internal)
  EventSignal<T>? $onMouseOut;

  /// (Internal)
  EventSignal<T>? $onMouseOver;

  /// (Internal)
  EventSignal<T>? $onMouseWheel;

  /// (Internal)
  EventSignal<T>? $onZoomPan;

  /// A signal that is dispatched when the mouse is clicked.
  EventSignal<T> get onMouseClick => $onMouseClick ??= EventSignal();

  /// A signal that is dispatched when the mouse is double clicked.
  EventSignal<T> get onMouseDoubleClick =>
      $onMouseDoubleClick ??= EventSignal();

  /// A signal that is dispatched when the right mouse button is pressed down.
  EventSignal<T> get onRightMouseDown => $onRightMouseDown ??= EventSignal();

  /// A signal that is dispatched when the mouse button is pressed down.
  EventSignal<T> get onMouseDown => $onMouseDown ??= EventSignal();

  /// A signal that is dispatched when the mouse button is released.
  EventSignal<T> get onMouseUp => $onMouseUp ??= EventSignal();

  /// A signal that is dispatched when the mouse is moved.
  EventSignal<T> get onMouseMove => $onMouseMove ??= EventSignal();

  /// A signal that is dispatched when the mouse is over a component.
  EventSignal<T> get onMouseOver => $onMouseOver ??= EventSignal();

  /// A signal that is dispatched when the mouse leaves a component.
  EventSignal<T> get onMouseOut => $onMouseOut ??= EventSignal();

  /// A signal that is dispatched when the mouse wheel is scrolled.
  EventSignal<T> get onMouseScroll => $onMouseWheel ??= EventSignal();

  /// A signal that is dispatched when a zoom/pan gesture is performed.
  ///
  /// This is available since Flutter 3.x.
  /// Use this event in favor of onMouseScroll on desktop.
  /// Might change in the future.
  EventSignal<T> get onZoomPan => $onZoomPan ??= EventSignal();

  /// Disposes all mouse signals to free up memory.
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
    $onZoomPan?.removeAll();
    $onZoomPan = null;
  }
}

/// A mixin that provides signals for pointer events.
mixin PointerSignalsMixin<T extends PointerEventData> {
  /// (Internal)
  EventSignal<T>? $onClick;

  /// (Internal)
  EventSignal<T>? $onDown;

  /// (Internal)
  EventSignal<T>? $onUp;

  /// (Internal)
  EventSignal<T>? $onHover;

  /// (Internal)
  EventSignal<T>? $onOut;

  /// (Internal)
  EventSignal<T>? $onScroll;

  /// (Internal)
  EventSignal<T>? $onZoomPan;

  /// Signal emitted when a pointer is clicked or tapped down and up within
  /// a certain amount of time and movement.
  EventSignal<T> get onClick => $onClick ??= EventSignal();

  /// Signal emitted when a pointer is pressed down.
  EventSignal<T> get onDown => $onDown ??= EventSignal();

  /// Signal emitted when a pointer is released up.
  EventSignal<T> get onUp => $onUp ??= EventSignal();

  /// Signal emitted when a pointer is hovering over the widget.
  EventSignal<T> get onHover => $onHover ??= EventSignal();

  /// Signal emitted when a pointer is no longer hovering over the widget.
  EventSignal<T> get onOut => $onOut ??= EventSignal();

  /// Signal emitted when a pointer generates a scroll event.
  EventSignal<T> get onScroll => $onScroll ??= EventSignal();

  /// Signal emitted when a pointer generates a zoom or pan event.
  EventSignal<T> get onZoomPan => $onZoomPan ??= EventSignal();

  /// Dispose all the registered signals.
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
    $onZoomPan?.removeAll();
    $onZoomPan = null;
  }
}
