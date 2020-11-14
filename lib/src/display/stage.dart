import 'dart:ui';

import '../../graphx.dart';
import '../core/scene_painter.dart';
import '../events/mixins.dart';
import 'display_object.dart';

class Stage extends DisplayObjectContainer
    with ResizeSignalMixin, TickerSignalMixin {
  final ScenePainter scene;

  static final _sMatrix = GxMatrix();

  bool maskBounds = false;

  @override
  String toString() {
    return '$runtimeType';
  }

  Size _size;
  Paint _backgroundPaint;
  DisplayBoundsDebugger _boundsDebugger;

  int get color => _backgroundPaint?.color?.value;

  set color(int value) {
    if (value == null) {
      _backgroundPaint = null;
    } else {
      _backgroundPaint ??= Paint();
      _backgroundPaint.color = Color(value);
    }
  }

  Juggler get juggler => Graphx.juggler;

  double get stageWidth => _size?.width ?? 0;

  double get stageHeight => _size?.height ?? 0;

  Stage(this.scene) {
//    $stage = this;
    $parent = null;
    _boundsDebugger = DisplayBoundsDebugger(this);
  }

  @override
  void paint(Canvas canvas) {
    /// scene start painting.
    if (maskBounds && _stageRectNative != null) {
      canvas.clipRect(_stageRectNative);
    }
    if (_backgroundPaint != null) {
      canvas.drawPaint(_backgroundPaint);
    }
    super.paint(canvas);
    if (DisplayBoundsDebugger.debugBoundsMode == DebugBoundsMode.stage) {
      _boundsDebugger.canvas = canvas;
      _boundsDebugger.render();
    }
  }

  final GxRect _stageRect = GxRect();
  GxRect get stageRect => _stageRect;
  Rect _stageRectNative;

  void $initFrameSize(Size value) {
    if (value != _size) {
      _size = value;
      _stageRectNative =
          _stageRect.setTo(0, 0, _size.width, _size.height).toNative();
      Graphics.updateStageRect(_stageRect);
      $onResized?.dispatch();
    }
  }

  KeyboardManager get keyboard {
    if (scene?.core?.keyboard == null) {
      throw 'You need to enable keyboard capture, define useKeyboard=true '
          'in your SceneController';
    }
    return scene?.core?.keyboard;
  }

  PointerManager get pointer {
    if (scene?.core?.pointer == null) {
      throw 'You need to enable pointer capture, define usePointer=true '
          'in your SceneController';
    }
    return scene?.core?.pointer;
  }

  @override
  bool hitTouch(GxPoint localPoint, [bool useShape = false]) => true;

  @override
  DisplayObject hitTest(GxPoint localPoint, [bool useShapes = false]) {
    if (!visible || !mouseEnabled) return null;

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
  void $tick(double delta) {
    $onEnterFrame?.dispatch(delta);
    super.update(delta);
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

  @override
  set width(double value) => throw 'Cannot set width of stage';

  @override
  set height(double value) => throw 'Cannot set height of stage';

  @override
  set x(double value) => throw 'Cannot set x-coordinate of stage';

  @override
  set y(double value) => throw 'Cannot set y-coordinate of stage';

  @override
  set scaleX(double value) => throw 'Cannot scale stage';

  @override
  set scaleY(double value) => throw 'Cannot scale stage';

  @override
  set pivotX(double value) => throw 'Cannot pivot stage';

  @override
  set pivotY(double value) => throw 'Cannot pivot stage';

  @override
  set skewX(double value) => throw 'Cannot skew stage';

  @override
  set skewY(double value) => throw 'Cannot skew stage';

  @override
  set rotation(double value) => throw 'Cannot rotate stage';
}
