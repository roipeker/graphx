import 'dart:ui' as ui;

// import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';

import '../../graphx.dart';

class ScenePainter with EventDispatcherMixin {
  /// Current painter being processed.
  static late ScenePainter current;

  /// access to SceneController defined in the Widget side.
  SceneController core;

  /// Access to the `root` DisplayObject that will initialize
  /// the Scene layer.
  GSprite root;

  /// Allows to re-paint the internal CustomPainter on every tick()
  /// The flags allow the $render() `tick` process to know if it has to
  /// [requestRender()] or not.
  ///
  /// See [CustomPainter.shouldRepaint()]
  bool needsRepaint = false;

  /// Warning: Experimental state
  bool useOwnCanvas = false;
  bool _ownCanvasNeedsRepaint = false;
  Canvas? $canvas;

  /// Size of the area available in `CustomPainter::paint()`
  Size size = Size.zero;

  /// Scene Layer's stage. The very first DisplayObject where the render
  /// display list starts.
  Stage? _stage;

  Stage? get stage => _stage;

  /// Defines when the Scene is ready and stage is accessible to GraphX root.
  /// Runs on the first "render".
  bool _isReady = false;


  bool get isReady => _isReady;

  /// Automatically manage the `tick()` and `render()` requests.
  /// Overrides [needsRepaint].
  bool autoUpdateAndRender = false;

  int $currentFrameId = 0;
  double $runTime = 0;

  double maxFrameTime = -1;
  double $currentFrameDeltaTime = 0;
  double $accumulatedFrameDeltaTime = 0;

  /// Ticker callback, to access the current frame delta timestamp
  /// (in millisecond).
  EventSignal<double>? _onUpdate;

  EventSignal<double> get onUpdate => _onUpdate ??= EventSignal<double>();

  ui.Picture? _canvasPicture;

  var _mouseMoveInputDetected = false;
  var _lastMouseX = -1000000.0;
  var _lastMouseY = -1000000.0;
  var _lastMouseOut = false;
  MouseInputData? _lastMouseInput;

  /// constructor.
  ScenePainter(this.core, this.root) {
    _stage = Stage(this);
    makeCurrent();
  }

  // ignore: use_to_and_as_if_applicable
  CustomPainter buildPainter() => _GraphicsPainter(this);

  /// Actual rendering from the `CustomPaint`.
  void _paint(Canvas canvas, Size size) {
    if (this.size != size) {
      this.size = size;
      _stage!.$initFrameSize(size);
    }
    $canvas = canvas;
    if (!_isReady) {
      _isReady = true;
      _initMouseInput();
      _stage!.addChild(root);
      _stage?.$onResized?.dispatch();
    }
    if (useOwnCanvas) {
      _pictureFromCanvas();
    } else {
      _stage!.paint($canvas);
    }
  }

  void $setup() {
    makeCurrent();

    /// If needed, can be overridden later by the [root].
    autoUpdateAndRender = core.config.autoUpdateRender;
  }

  void _createPicture() {
    final _recorder = ui.PictureRecorder();
    final _canvas = Canvas(_recorder);
    _stage!.paint(_canvas);
    _canvasPicture = _recorder.endRecording();
  }

  /// The main `enterFrame`, called from the `SceneController` unique `GxTicker`
  /// only valid when there's a GxTicker running.
  /// Manages the `update()` and can request to redraw the CustomPainter.
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

  /// Update inner display list.
  void $update(double deltaTime) {
    if (maxFrameTime != -1 && deltaTime > maxFrameTime) {
      deltaTime = maxFrameTime;
    }
    $currentFrameDeltaTime = deltaTime;
    $accumulatedFrameDeltaTime += $currentFrameDeltaTime;
    _stage!.$tick(deltaTime);
    if (_hasPointer) {
      _detectMouseMove();
    }
  }

  void _detectMouseMove() {
    // If there was no mouse move dispatch a still event this handles static mouse OVER/OUT for moving/hiding objects
    if (!_mouseMoveInputDetected && _lastMouseX != -1000000) {
      final input = MouseInputData(
        target: _stage,
        dispatcher: _stage,
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

  /// Requests a new frame.
  void $render() {
    if (autoUpdateAndRender || needsRepaint) {
      requestRender();
    }
  }

  /// Direct way to ask painter invalidation.
  /// Can be called manually, without the need for a `tick()` event.
  /// Might be useful for re-paint the `CustomPainter` on keyboard on pointer
  /// signals.
  void requestRender() {
    notify();
  }

  void _initMouseInput() {
    core.pointer.onInput.add(_onInputHandler);
  }

  void _onInputHandler(PointerEventData e) {
    var input = MouseInputData(
      target: stage,
      dispatcher: stage,
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

  void makeCurrent() {
    ScenePainter.current = this;
  }

  void _pictureFromCanvas() {
    if (_ownCanvasNeedsRepaint) {
      _ownCanvasNeedsRepaint = false;
      _createPicture();
    }
    if (_canvasPicture != null) {
      $canvas!.drawPicture(_canvasPicture!);
    }
  }

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

  bool get _hasPointer => core.pointer.onInput != null;
  bool shouldRepaint() => needsRepaint;
}

class _GraphicsPainter extends CustomPainter {
  final ScenePainter scene;

  _GraphicsPainter(this.scene) : super(repaint: scene);

  @override
  void paint(Canvas canvas, Size size) {
    scene._paint(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      scene.shouldRepaint();
}
