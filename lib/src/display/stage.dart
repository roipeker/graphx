import 'dart:ui' as ui;
import '../../graphx.dart';
import '../events/mixins.dart';

/// The Stage class represents the main drawing area.
/// The Stage represents the entire area where a GraphX `ScenePainter` content
/// is shown.
/// Each `ScenePainter` object has a corresponding `Stage` object, owned by a
/// `SceneController`, which can contain a `back` and `front` SceneLayers.
///
/// The `Stage` object is not globally accessible.
/// You need to access it through the `stage` property of a `DisplayObject`
/// instance.
///
/// The `Stage` class has several ancestor classes — DisplayObjectContainer,
/// DisplayObject — from which it inherits properties and methods.
/// Many of these properties and methods are either to the `Stage` object
/// usually to keep a common API with Flash.
///
/// In addition, the following inherited properties are inapplicable to `Stage`
/// objects. If you try to set them, an Error is thrown.
/// These properties may always be read, but since they cannot be set,
/// they will always contain default values:
/// x, y, width, height, stageWidth, stageHeight, mask, name, filter.
class Stage extends GDisplayObjectContainer
    with ResizeSignalMixin, TickerSignalMixin, StageMouseSignalsMixin {
  final ScenePainter scene;

  static final _sMatrix = GMatrix();

  bool maskBounds = false;

  @override
  String toString() {
    return '$runtimeType';
  }

  ui.Size _size;
  ui.Paint _backgroundPaint;
  DisplayBoundsDebugger _boundsDebugger;

  /// Shortcut to access the owner [SceneController].
  SceneController get controller => scene.core;

  /// Shortcut for `onHotReload` Signal.
  Signal get onHotReload => controller.onHotReload;

  /// The `backgroundPaint` hex color.
  ui.Color get color => _backgroundPaint?.color;

  /// Sets the `backgroundPaint` Color.
  set color(ui.Color value) {
    if (value == null) {
      _backgroundPaint = null;
    } else {
      _backgroundPaint ??= ui.Paint();
      _backgroundPaint.color = value;
    }
  }

  /// Debug stage/scene canvas area.
  /// Drawing a black 2px line square around it.
  bool showBoundsRect = false;

  /// The current width of the Stage.
  double get stageWidth => _size?.width ?? 0;

  /// The current height of the Stage.
  double get stageHeight => _size?.height ?? 0;

  /// Should only be initialized by the `ScenePainter`.
  Stage(this.scene) {
//    $stage = this;
    $parent = null;
    _boundsDebugger = DisplayBoundsDebugger(this);
  }

  @override
  void paint(ui.Canvas canvas) {
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
    if (showBoundsRect) {
      canvas.drawPath(_stageBoundsRectPath, _stageBoundsRectPaint);
    }
  }

  ui.Path _stageBoundsRectPath = ui.Path();
  static final ui.Paint _stageBoundsRectPaint = ui.Paint()
    ..style = ui.PaintingStyle.stroke
    ..color = kColorBlack
    ..strokeWidth = 2;

  final GRect _stageRect = GRect();
  GRect get stageRect => _stageRect;
  ui.Rect _stageRectNative;

  void $initFrameSize(ui.Size value) {
    if (value != _size) {
      _size = value;
      _stageRectNative =
          _stageRect.setTo(0, 0, _size.width, _size.height).toNative();
      _stageBoundsRectPath ??= ui.Path();
      _stageBoundsRectPath.reset();
      _stageBoundsRectPath.addRect(_stageRectNative);
      _stageBoundsRectPath.close();
      Graphics.updateStageRect(_stageRect);
      $onResized?.dispatch();
    }
  }

  /// Access the keyboard instance of the owner `SceneController`,
  /// Only available when [SceneConfig.useKeyboard] is true.
  KeyboardManager get keyboard {
    if (scene?.core?.keyboard == null) {
      throw 'You need to enable keyboard capture, define useKeyboard=true '
          'in your SceneController';
    }
    return scene?.core?.keyboard;
  }

  /// Access the pointer (mouse or touch info) instance of the
  /// owner `SceneController`,
  /// Only available when [SceneConfig.usePointer] is true.
  PointerManager get pointer {
    if (scene?.core?.pointer == null) {
      throw 'You need to enable pointer capture, define usePointer=true '
          'in your SceneController';
    }
    return scene?.core?.pointer;
  }

  @override
  bool hitTouch(GPoint localPoint, [bool useShape = false]) => true;

  @override
  GDisplayObject hitTest(GPoint localPoint, [bool useShapes = false]) {
    if (!visible || !mouseEnabled) return null;

    /// location outside stage area, is not accepted.
    if (localPoint.x < 0 ||
        localPoint.x > stageWidth ||
        localPoint.y < 0 ||
        localPoint.y > stageHeight) return null;

    /// if nothing is hit, stage returns itself as target.
    return super.hitTest(localPoint) ?? this;
  }

  bool _isMouseInside = false;

  /// tells if the pointer is inside the stage area (available to detect
  /// events).
  bool get isMouseInside => _isMouseInside;

  /// capture context mouse inputs.
  @override
  void captureMouseInput(MouseInputData input) {
    if (input.type == MouseInputType.exit) {
      _isMouseInside = false;
      var mouseInput = input.clone(this, this, input.type);
      $onMouseLeave?.dispatch(mouseInput);
    } else if (input.type == MouseInputType.unknown && !_isMouseInside) {
      _isMouseInside = true;
      $onMouseEnter?.dispatch(input.clone(this, this, MouseInputType.enter));
    } else {
      super.captureMouseInput(input);
    }
  }

  GRect getStageBounds(GDisplayObject targetSpace, [GRect out]) {
    out ??= GRect();
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
    pointer?.dispose();
    keyboard?.dispose();
    $disposeResizeSignals();
    $disposeTickerSignals();
    $disposeStagePointerSignals();
    super.dispose();
  }

  @override
  double get width => throw 'Use `stage.stageWidth` instead.';

  @override
  double get height => throw 'Use `stage.stageHeight` instead.';

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
