import 'dart:ui';

import 'package:graphx/graphx/display/display_object_container.dart';
import 'package:graphx/graphx/geom/gxmatrix.dart';
import 'package:graphx/graphx/geom/gxpoint.dart';
import 'package:graphx/graphx/geom/gxrect.dart';
import 'package:graphx/graphx/input/keyboard_manager.dart';
import 'package:graphx/graphx/input/pointer_manager.dart';

import '../events/mixins.dart';
import '../scene_painter.dart';
import 'display_object.dart';

class Stage extends DisplayObjectContainer
    with ResizeSignalMixin, TickerSignalMixin {
  final ScenePainter scene;

  static GxMatrix _sMatrix = GxMatrix();

  @override
  String toString() {
    return '$runtimeType';
  }

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

  @override
  DisplayObject hitTest(GxPoint localPoint) {
    if (!visible || !touchable) return null;

    /// location outside stage area, is not accepted.
    if (localPoint.x < 0 ||
        localPoint.x > stageWidth ||
        localPoint.y < 0 ||
        localPoint.y > stageHeight) return null;

    /// if nothing is hit, stage returns itself as target.
    return super.hitTest(localPoint) ?? this;
  }

  GxRect getStageBounds(DisplayObject targetSpace, [GxRect out]) {
    out ??= GxRect();
    out.setTo(0, 0, stageWidth, stageHeight);
    getTransformationMatrix(targetSpace, _sMatrix);
    return out.getBounds(_sMatrix, out);
  }

  /// TODO: need to find a way to reference the window.
//  GxRect getScreenBounds(DisplayObject targetSpace, [GxRect out]) {
//    out ??= GxRect();
//    out.setTo(0, 0, stageWidth, stageHeight);
//    getTransformationMatrix(targetSpace, _sMatrix);
//    return out.getBounds(_sMatrix, out);
//  }

  /// advance time... (passedTime)
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
