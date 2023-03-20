import 'dart:ui' as ui;

import '../../graphx.dart';

/// The Stage is the root display container for a GraphX scene.
/// It extends the [GDisplayObjectContainer] class and provides a canvas to
/// which you can draw objects, as well as handling resize and tick events.
///
/// The [Stage] has a [ScenePainter] that defines the scene's [SceneController].
/// It is responsible for updating the scene and painting the display tree.
/// It also mixes in various signal mix-ins to enable the dispatching of resize,
/// tick and mouse input events to the scene and display tree.
///
/// The [Stage] has a size ([stageWidth] and [stageHeight]) that can be set by the
/// parent container.
///
/// The [Stage] class overrides the [hitTest] method to ensure that mouse events
/// are only dispatched to visible and mouse-enabled objects within the stage's
/// bounds.
///
/// The [Stage] class provides the [mouseX] and [mouseY] properties to get the
/// current mouse position within the stage's bounds. It also overrides various
/// properties and methods from [GDisplayObject] that are not applicable to the
/// stage, such as [width], [height], [x], [y], [scaleX], [scaleY], [pivotX],
/// [pivotY], [skewX], [skewY], and [rotation].
class Stage extends GDisplayObjectContainer
    with ResizeSignalMixin, TickerSignalMixin, StageMouseSignalsMixin {
  /// The scene painter that defines the scene's [SceneController].
  final ScenePainter scene;

  static final _sMatrix = GMatrix();

  /// The native canvas bounds will be clipped to the bounds of the stage if
  /// [maskBounds] is set to `true`.
  bool maskBounds = false;

  /// If set to `true`, mouse events will be dispatched to objects that are not
  /// directly below the mouse pointer but still receive mouse events (like
  /// mouse move events).
  bool mouseEnableStillEvents = true;

  /// Returns a string representation of this instance.
  @override
  String toString() {
    return '$runtimeType';
  }

  ui.Size? _size;

  /// The background color of the stage.
  ui.Paint? _backgroundPaint;

  /// A debugger used to display the bounds of the display objects in the scene.
  late DisplayBoundsDebugger _boundsDebugger;

  /// Gets the owner [SceneController] for the stage.
  SceneController get controller => scene.core;

  /// A signal that is dispatched when the scene is reloaded (for hot-reloading
  /// purposes).
  Signal get onHotReload => controller.onHotReload;

  /// Gets the background color (in [backgroundPaint]) of the stage.
  ui.Color? get color => _backgroundPaint?.color;

  /// Sets the background color (in [backgroundPaint]) of the stage.
  set color(ui.Color? value) {
    if (value == null) {
      _backgroundPaint = null;
    } else {
      _backgroundPaint ??= ui.Paint();
      _backgroundPaint!.color = value;
    }
  }

  /// Determines whether to display the bounds of the stage area
  /// drawing a 2px black line square around it.
  /// Useful to debug if the mouse touches are not working because the widget
  /// is not covering the whole screen.
  bool showBoundsRect = false;

  /// The current width of the Stage.
  double get stageWidth => _size?.width ?? 0;

  /// The current height of the Stage.
  double get stageHeight => _size?.height ?? 0;

  /// Initializes a new instance of the [Stage] class.
  /// Should only be initialized by the [ScenePainter].
  Stage(this.scene) {
//    $stage = this;
    $parent = null;
    _boundsDebugger = DisplayBoundsDebugger(this);
  }

  /// Renders this stage on the given canvas.
  @override
  void paint(ui.Canvas canvas) {
    /// scene start painting.
    if (maskBounds && _stageRectNative != null) {
      canvas.clipRect(_stageRectNative!);
    }
    if (_backgroundPaint != null) {
      canvas.drawPaint(_backgroundPaint!);
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

  final ui.Path _stageBoundsRectPath = ui.Path();

  /// The stage bounds rectangle paint.
  static final ui.Paint _stageBoundsRectPaint = ui.Paint()
    ..style = ui.PaintingStyle.stroke
    ..color = kColorBlack
    ..strokeWidth = 2;

  final GRect _stageRect = GRect();

  /// Returns the bounds of the stage as a [GRect].
  GRect get stageRect => _stageRect;

  /// The native stage rectangle bounds.
  ui.Rect? _stageRectNative;

  /// (internal)
  /// Initializes the size of the stage.
  void $initFrameSize(ui.Size value) {
    if (value != _size) {
      _size = value;
      if (_size!.isEmpty) {
        trace(
          // ignore: lines_longer_than_80_chars
          "WARNING:\n\tStage has size <= 0 in width or height. "
          "If you rely on stage size for a responsive layout or rendering,"
          " make sure SceneBuilderWidget() has some child,"
          " or the parent is defining the constraints.",
        );
      }
      _stageRectNative =
          _stageRect.setTo(0, 0, _size!.width, _size!.height).toNative();
      _stageBoundsRectPath.reset();
      _stageBoundsRectPath.addRect(_stageRectNative!);
      _stageBoundsRectPath.close();
      Graphics.updateStageRect(_stageRect);
      $onResized?.dispatch();
    }
  }

  /// Access the keyboard instance of the owner `SceneController`,
  /// Only available when [SceneConfig.useKeyboard] is true.
  KeyboardManager? get keyboard {
    return scene.core.keyboard;
  }

  /// Access the pointer (mouse or touch info) instance of the
  /// owner `SceneController`,
  /// Only available when [SceneConfig.usePointer] is true.
  PointerManager? get pointer {
    return scene.core.pointer;
  }

  /// Checks whether a [localPoint] inside the object's boundary.
  /// This method always returns `true` for the `Stage` object, because it occupies
  /// the entire screen and it should always receive touch events.
  ///
  /// If [useShape] is `true`, the method will use the object's shape to check
  /// whether the point is inside it, instead of using its bounding box.
  ///
  /// Returns `true` if the point is inside the stage's boundary, or `false`
  /// otherwise.
  @override
  bool hitTouch(GPoint localPoint, [bool useShape = false]) => true;

  /// Returns the deepest [GDisplayObject] that lies under the given point.
  ///
  /// The [localPoint] parameter is the point to check for an object under it.
  ///
  /// The [useShape] parameter is not used in this implementation.
  ///
  /// Returns the [GDisplayObject] that lies under the given point or `null` if
  /// there is no such object.
  @override
  GDisplayObject? hitTest(GPoint localPoint, [bool useShape = false]) {
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

  /// Returns a boolean indicating whether the mouse pointer is inside the stage.
  /// So if it's available to detect events.
  bool get isMouseInside => _isMouseInside;

  /// Captures the [MouseInputData] and processes it to update mouse input state
  /// and dispatch [MouseEvent] signals on this [Stage] or its children.
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

  /// Returns the bounds of the [Stage] object in the coordinate system
  /// specified by the [targetSpace] object.
  /// If the [out] parameter is provided, the result is stored in that object.
  /// Otherwise, a new [GRect] object is created and returned.
  ///
  /// If the [targetSpace] parameter is null or unspecified, the bounds are
  /// returned in the global coordinate system.
  ///
  /// The [targetSpace] object can be any [GDisplayObject], including the
  /// [Stage] object itself.
  GRect getStageBounds(GDisplayObject targetSpace, [GRect? out]) {
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

  /// Updates the [Stage] object and dispatches the `enterFrame` event with
  /// the [delta] time since the last frame, in seconds.
  void $tick(double delta) {
    $onEnterFrame?.dispatch(delta);
    super.update(delta);
  }

  /// Disposes the [Stage] object, releasing any resources used by it and
  /// removing it from the display list.
  @override
  void dispose() {
    _size = null;
    _backgroundPaint = null;
    scene.core.pointer.dispose();
    scene.core.keyboard.dispose();
    $disposeResizeSignals();
    $disposeTickerSignals();
    $disposeStagePointerSignals();
    super.dispose();
  }

  /// Returns the current x-coordinate of the mouse pointer on the stage.
  @override
  double get mouseX => pointer!.mouseX;

  /// Returns the current y-coordinate of the mouse pointer on the stage.
  @override
  double get mouseY => pointer!.mouseY;

  // Throws an error. Is to comply with the [GDisplayObject] API.
  // Use `stageWidth` property instead.
  @override
  double get width => throw 'Use `stage.stageWidth` instead.';

  // Throws an error. Is to comply with the [GDisplayObject] API.
  // Use `stageHeight` property instead.
  @override
  double get height => throw 'Use `stage.stageHeight` instead.';

  /// The `width` setter is overridden to throw an error since the stage's
  /// height is defined by the size of the canvas and cannot be changed directly.
  @override
  set width(double? value) => throw 'Cannot set width of stage';

  /// The `height` setter is overridden to throw an error since the stage's
  /// height is defined by the size of the canvas and cannot be changed directly.
  @override
  set height(double? value) => throw 'Cannot set height of stage';

  /// Throws an error as the `x` coordinate of the stage cannot be set.
  @override
  set x(double? value) => throw 'Cannot set x-coordinate of stage';

  /// Throws an error as the `y` coordinate of the stage cannot be set.
  @override
  set y(double? value) => throw 'Cannot set y-coordinate of stage';

  /// Throws an error as the `scaleX` property of the stage cannot be set.
  @override
  set scaleX(double? value) => throw 'Cannot scale stage';

  /// Throws an error as the `scaleY` property of the stage cannot be set.
  @override
  set scaleY(double? value) => throw 'Cannot scale stage';

  /// Throws an error as the `pivotX` property of the stage cannot be set.
  @override
  set pivotX(double value) => throw 'Cannot pivot stage';

  /// Throws an error as the `pivotY` property of the stage cannot be set.
  @override
  set pivotY(double value) => throw 'Cannot pivot stage';

  /// Throws an error as the `skewX` property of the stage cannot be set.
  @override
  set skewX(double value) => throw 'Cannot skew stage';

  /// Throws an error as the `skewY` property of the stage cannot be set.
  @override
  set skewY(double value) => throw 'Cannot skew stage';

  /// This operation is not allowed for the stage and will throw an exception
  /// if called.
  @override
  set rotation(double? value) => throw 'Cannot rotate stage';
}
