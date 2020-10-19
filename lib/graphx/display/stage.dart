import 'dart:ui';

import 'package:graphx/graphx/display/display_object_container.dart';
import 'package:graphx/graphx/input/keyboard_manager.dart';
import 'package:graphx/graphx/input/pointer_manager.dart';

import '../events/mixins.dart';
import '../scene_painter.dart';

class Stage extends DisplayObjectContainer
    with ResizeSignalMixin, TickerSignalMixin {
  final ScenePainter scene;

  Size _size;
  Paint _backgroundPaint;
  int get color => _backgroundPaint?.color?.value;

  set color(int value) {
    if (value == null) {
      _backgroundPaint = null;
    } else {
      _backgroundPaint ??= Paint();
      _backgroundPaint.color = Color(value);
    }
  }

  double get stageWidth => _size?.width ?? 0;

  double get stageHeight => _size?.height ?? 0;

  Stage(this.scene) {
//    $stage = this;
    $parent = null;
  }

  @override
  void paint(Canvas canvas) {
    /// scene start painting.
    if (_backgroundPaint != null) {
      canvas.drawPaint(_backgroundPaint);
    }
    super.paint(canvas);
  }

  void $initFrameSize(Size value) {
    if (value != _size) {
      _size = value;
      $onResized?.dispatch();
    }
  }

  KeyboardManager get keyboard {
    if (scene?.core?.keyboard == null)
      throw 'You need to enable keyboard capture, define useKeyboard=true in your SceneController';
    return scene?.core?.keyboard;
  }

  PointerManager get pointer {
    if (scene?.core?.pointer == null)
      throw 'You need to enable pointer capture, define usePointer=true in your SceneController';
    return scene?.core?.pointer;
  }

  void $tick() {
    $onEnterFrame?.dispatch();
  }

  @override
  void dispose() {
    _size = null;
    _backgroundPaint = null;
    $disposeDisplayListSignals();
    $disposeResizeSignals();
    $disposeTickerSignals();
    super.dispose();
  }
}
