import 'dart:ui' as ui;

// import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';

import '../../graphx.dart';

/// The `ScenePainter` class is responsible for rendering and managing the
/// GraphX scene. It is a mixin that can be used with a custom painter to draw
/// graphics within a Flutter widget. This class contains methods and properties
/// to handle updates, rendering, and mouse input events. It also manages the
/// `Stage` instance, which is the root of the display list for the GraphX
/// scene.
///
/// By default, the `ScenePainter` will repaint the custom painter on every tick
/// of the animation loop. This behavior can be overridden by setting
/// `autoUpdateAndRender` to `false`. You can also manually trigger a repaint
/// using the `requestRender()` method.
class ScenePainter with EventDispatcherMixin {
  /// The currently processed painter.
  static late ScenePainter current;

  /// The `SceneController` that this `ScenePainter` belongs to.
  SceneController core;

  /// The [root] `DisplayObject` that initializes the Scene layer.
  GSprite root;

  /// Indicates whether the internal `CustomPainter` needs repainting on each
  /// tick. The flags allow the `$render()` process to know if it has to
  /// [requestRender()] or not.
  ///
  /// See [CustomPainter.shouldRepaint]
  bool needsRepaint = false;

  /// Warning: Experimental state
  bool useOwnCanvas = false;

  /// Indicates whether the internal canvas for the ScenePainter's custom paint
  /// widget needs to be repainted on each tick. The flag allows the $render()
  /// process to know if it has to [requestRender()] or not. Used only if
  /// [useOwnCanvas] is true.
  bool _ownCanvasNeedsRepaint = false;

  /// (Internal usage)
  /// The current canvas being drawn on by the [ScenePainter].
  late Canvas $canvas;

  /// The size of the area available in `CustomPainter::paint()`.
  Size size = Size.zero;

  /// The stage of the scene layer. The first `DisplayObject` where the render
  /// display list starts.
  Stage? _stage;

  /// Indicates whether the Scene is ready and the stage is accessible to the
  /// GraphX root. Runs on the first "render".
  bool _isReady = false;

  /// Automatically manages the `tick()` and `render()` requests. Overrides
  /// [needsRepaint].
  bool autoUpdateAndRender = false;

  /// (Internal usage)
  /// The current frame ID.
  int $currentFrameId = 0;

  /// (Internal usage)
  /// The current runtime.
  double $runTime = 0;

  /// The maximum time of a frame.
  double maxFrameTime = -1;

  /// (Internal usage)
  /// The current frame delta timestamp (in milliseconds).
  double $currentFrameDeltaTime = 0;

  /// (Internal usage)
  /// The accumulated frame delta timestamp (in milliseconds).
  double $accumulatedFrameDeltaTime = 0;

  /// Ticker callback, to access the current frame delta timestamp (in
  /// millisecond).
  EventSignal<double>? _onUpdate;

  /// The current picture of the canvas.
  ui.Picture? _canvasPicture;

  /// Indicates whether a mouse movement event has been detected.
  bool _mouseMoveInputDetected = false;

  /// The last known X coordinate of the mouse pointer.
  double _lastMouseX = -1000000.0;

  /// The last known Y coordinate of the mouse pointer.
  double _lastMouseY = -1000000.0;

  /// Whether the mouse pointer is currently outside the boundaries of the
  /// [Stage].
  bool _lastMouseOut = false;

  /// The last [MouseInputData] object received by the [ScenePainter].
  MouseInputData? _lastMouseInput;

  /// Creates a new `ScenePainter` with the given `SceneController` and [root].
  ScenePainter(this.core, this.root) {
    _stage = Stage(this);
    makeCurrent();
  }

  bool get isReady => _isReady;

  /// Dispatched when the frame is updated.
  EventSignal<double> get onUpdate => _onUpdate ??= EventSignal<double>();

  Stage? get stage => _stage;

  /// Requests a new frame.
  void $render() {
    if (autoUpdateAndRender || needsRepaint) {
      requestRender();
    }
  }

  /// This method is called from the SceneController's ScenePainter's
  /// constructor, and sets up the autoUpdateAndRender flag to the value of
  /// SceneConfig autoUpdateRender. It also sets the current ScenePainter
  /// instance to this instance.
  void $setup() {
    makeCurrent();

    /// If needed, can be overridden later by the [root].
    autoUpdateAndRender = core.config.autoUpdateRender;
  }

  /// (Internal usage)
  /// This method updates the display list and detects any mouse movement.
  /// Tickers entry point (aka `enterFrame`).
  void $update(double deltaTime) {
    if (maxFrameTime != -1 && deltaTime > maxFrameTime) {
      deltaTime = maxFrameTime;
    }
    $currentFrameDeltaTime = deltaTime;
    $accumulatedFrameDeltaTime += $currentFrameDeltaTime;
    _stage!.$tick(deltaTime);
// if (_hasPointer) {
    _detectMouseMove();
// }
  }

  // ignore: use_to_and_as_if_applicable
  CustomPainter buildPainter() => _GraphicsPainter(this);

  /// Reset the state of the ScenePainter object
  @override
  void dispose() {
    _isReady = false;
    size = Size.zero;
    _stage?.dispose();
    core.pointer.onInput.remove(_onInputHandler);
    _onUpdate?.removeAll();
    _onUpdate = null;
    super.dispose();
  }

  /// This method sets the [ScenePainter.current] to this instance.
  /// Currently not used.
  void makeCurrent() {
    ScenePainter.current = this;
  }

  /// Direct way to ask painter invalidation.
  /// Can be called manually, without the need for a `tick()` event.
  /// Might be useful for re-paint the `CustomPainter` on keyboard on pointer
  /// signals.
  void requestRender() {
    notify();
  }

  // bool get _hasPointer => core.pointer.onInput != null;
  bool shouldRepaint() => needsRepaint;

  /// This method is called every tick() and updates the display list if
  /// autoUpdateAndRender is true, and calls _onUpdate?.dispatch(time).
  /// It then calls $render(), and if useOwnCanvas is true, sets
  /// _ownCanvasNeedsRepaint to true.
  void tick(double time) {
    makeCurrent();
    if (autoUpdateAndRender) {
      $currentFrameId++;
      $runTime += time;
      $update(time);
    }
    _onUpdate?.dispatch(time);
    $render();
    if (useOwnCanvas) {
      _ownCanvasNeedsRepaint = true;
    }
  }

  /// This method creates a picture recorder and a canvas, and draws the [Stage]
  /// to it.
  void _createPicture() {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    _stage!.paint(canvas);
    _canvasPicture = recorder.endRecording();
  }

  /// This method detects mouse movement, and dispatches a "still" event if no
  /// movement was detected. If movement was detected, it sets _lastMouseX and
  /// _lastMouseY to the current mouse coordinates. If the mouse has left the
  /// stage, it sets _lastMouseOut to true. It then calls
  /// stage!.captureMouseInput(input) with input being the [MouseInputData].
  void _detectMouseMove() {
    // If there was no mouse move, dispatch a still event.
    // This handles static mouse OVER/OUT for moving/hiding objects.
    if (_stage!.mouseEnableStillEvents &&
        !_mouseMoveInputDetected &&
        _lastMouseX != -1000000) {
      final input = MouseInputData(
        target: _stage,
        dispatcher: _stage!,
        type: MouseInputType.still,
      );
      input.uid = ++MouseInputData.uniqueId;
      input.localPosition.setTo(_lastMouseX, _lastMouseY);
      input.stagePosition.setTo(_lastMouseX, _lastMouseY);
      input.mouseOut = _lastMouseOut;
      if (_lastMouseInput != null) {
        input.buttonDown = _lastMouseInput!.buttonDown;
        input.rawEvent = _lastMouseInput!.rawEvent;
        input.buttonsFlags = _lastMouseInput!.buttonsFlags;
      }
      _mouseInputHandler(input);
    }
    _mouseMoveInputDetected = false;
  }

  /// This method detects mouse movement, and dispatches a "still" event if no
  /// movement was detected. If movement was detected, it sets _lastMouseX and
  /// _lastMouseY to the current mouse coordinates. If the mouse has left the
  /// stage, it sets _lastMouseOut to true.
  void _mouseInputHandler(MouseInputData input) {
    input.time = $accumulatedFrameDeltaTime;
    // if (input.type != MouseInputType.still) {
    //   trace(input.type);
    // }
    /// process it.
    if (input.type == MouseInputType.move ||
        input.type == MouseInputType.exit) {
      _mouseMoveInputDetected = true;
      _lastMouseX = input.stageX;
      _lastMouseY = input.stageY;
      // mouse leave.
      _lastMouseOut = input.mouseOut;
    } else if (input.type == MouseInputType.down) {
      _lastMouseX = input.stageX;
      _lastMouseY = input.stageY;
    }
    _lastMouseInput = input;

    stage!.captureMouseInput(input);
  }

  /// Handles the [PointerEventData] and creates a [MouseInputData] instance
  /// to be dispatched to the [SceneController] and all the [DisplayObject]s
  /// in the display list.
  void _onInputHandler(PointerEventData e) {
    var input = MouseInputData(
      target: stage,
      dispatcher: stage!,
      type: MouseInputData.fromNativeType(e.type),
    );
    input.rawEvent = e;
    input.buttonsFlags = e.rawEvent.buttons;
    input.buttonDown = e.rawEvent.down;
    input.localPosition.setTo(e.localX, e.localY);
    input.scrollDelta.setTo(e.scrollDelta?.dx ?? 0, e.scrollDelta?.dy ?? 0);
    input.stagePosition.setTo(e.stagePosition.x, e.stagePosition.y);
    input.uid = ++MouseInputData.uniqueId;
    if (input.type == MouseInputType.exit) {
      input.mouseOut = true;
    }
    _mouseInputHandler(input);
  }

  /// Renders from the [CustomPaint].
  void _paint(Canvas canvas, Size size) {
    if (this.size != size) {
      this.size = size;
      _stage!.$initFrameSize(size);
    }
    $canvas = canvas;
    if (!_isReady) {
      _isReady = true;
      core.pointer.onInput.add(_onInputHandler);
      _stage!.addChild(root);
      _stage?.$onResized?.dispatch();
    }
    if (useOwnCanvas) {
      _pictureFromCanvas();
    } else {
      _stage!.paint(canvas);
    }
  }

  /// Converts the internal canvas to a picture and draws it onto the
  /// current [$canvas].
  void _pictureFromCanvas() {
    if (_ownCanvasNeedsRepaint) {
      _ownCanvasNeedsRepaint = false;
      _createPicture();
    }
    if (_canvasPicture != null) {
      $canvas.drawPicture(_canvasPicture!);
    }
  }
}

/// A custom painter that delegates to the given [ScenePainter].
///
/// This custom painter is used to wrap a [ScenePainter] instance and delegate
/// the paint and [shouldRepaint] methods to it. It also provides a repaint
/// callback to the [ScenePainter] instance to notify it of a repaint request.
class _GraphicsPainter extends CustomPainter {
  /// The [ScenePainter] instance that owns this painter.
  final ScenePainter scene;

  /// Creates a [_GraphicsPainter] instance.
  _GraphicsPainter(this.scene) : super(repaint: scene);

  @override
  void paint(Canvas canvas, Size size) {
    scene._paint(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      scene.shouldRepaint();
}
