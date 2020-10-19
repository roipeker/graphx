import 'dart:collection';
import 'dart:ui';

import 'package:flutter/foundation.dart';

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
}
