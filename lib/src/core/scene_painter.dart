import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import '../../graphx.dart';

class SceneRoot extends Sprite {
  ScenePainter scene;

  bool _ready = false;

  bool get isReady => _ready;

  bool _autoUpdateAndRender;
  bool _useTicker;
  bool _useKeyboard;
  bool _usePointer;
  bool _sceneIsComplex;

  /// You can config the scene in [init()] or in your class constructor.
  void config({
    bool autoUpdateAndRender = false,
    bool useTicker,
    bool useKeyboard,
    bool usePointer,
    bool sceneIsComplex,
  }) {
    _autoUpdateAndRender = autoUpdateAndRender;
    _useTicker = useTicker;
    _useKeyboard = useKeyboard;
    _usePointer = usePointer;
    _sceneIsComplex = sceneIsComplex;
    _applyConfig();
  }

  void _applyConfig() {
    if (scene == null) return;
    if (_ready) {
      throw 'You can not initScene() after ready() has happened. Is only allowed during (or before) init().';
    }
//    scene.shouldRepaint = needsRepaint;
    scene.autoUpdateAndRender = _autoUpdateAndRender ?? false;
    if (scene.autoUpdateAndRender) {
      _useTicker = true;
    }
    scene.core.config.setTo(
      useTicker: _useTicker,
      useKeyboard: _useKeyboard,
      usePointer: _usePointer,
      sceneIsComplex: _sceneIsComplex,
    );
  }

  /// Use to initialize engine properties.
  @protected
  void init() {
    _applyConfig();
  }

  /// Called when stage is ready.
  @protected
  void ready() {}
}

class ScenePainter with EventDispatcherMixin {
  /// Current painter being processed.
  static ScenePainter current;

  /// access to SceneController defined in the Widget side.
  SceneController core;

  /// acccess to the `root` DisplayObject that will initialize
  /// the Scene layer.
  SceneRoot root;

  /// Allows to re-paint the internal CustomPainter on every tick()
  /// The flags allow the $render() `tick` process to know if it has to
  /// [requestRender()] or not.
  ///
  /// See [CustomPainter.shouldRepaint()]
  bool needsRepaint = false;

  /// Warning: Experimental state
  bool useOwnCanvas = false;
  bool _ownCanvasNeedsRepaint = false;
  Canvas $canvas;

  /// Size of the area available in `CustomPainter::paint()`
  Size size = Size.zero;

  /// Scene Layer's stage. The very first DisplayObject where the render
  /// display list starts.
  Stage _stage;

  Stage get stage => _stage;

  /// Defines when the Scene is ready and stage is accessible to GraphX root.
  /// Runs on the first "render".
  bool _isReady = false;

  bool get isReady => _isReady;

  /// Automatically manage the `tick()` and `render()` requests.
  /// Overrides [SceneConfig.useTicker] and [needsRepaint].
  bool autoUpdateAndRender = false;

  int $currentFrameId = 0;
  double $runTime = 0;

  double maxFrameTime = -1;
  double $currentFrameDeltaTime = 0;
  double $accumulatedFrameDeltaTime = 0;

  /// Ticker callback, to access the current frame delta timestamp (in millisecond).
  EventSignal<double> _onUpdate;

  EventSignal<double> get onUpdate => _onUpdate ??= EventSignal<double>();

  ui.Picture _canvasPicture;
  ui.Image _canvasImage;

  ScenePainter(this.core, this.root) {
    _stage = Stage(this);
    root.scene = this;
    makeCurrent();
  }

  CustomPainter buildPainter() => _GraphicsPainter(this);

  /// Actual rendering from the `CustomPaint`.
  void _paint(Canvas p_canvas, Size p_size) {
    if (size != p_size) {
      size = p_size;
      _stage.$initFrameSize(p_size);
    }
    $canvas = p_canvas;
    if (!_isReady) {
      _isReady = true;
      _initMouseInput();
      _stage.addChild(root);
      root._ready = true;
      root.ready();
    }

    if (useOwnCanvas) {
      _pictureFromCanvas();
    } else {
      _stage.paint($canvas);
    }
  }

  void $setup() {
    makeCurrent();
    root._applyConfig();
    root.init();
  }

//  final stopWatch = Stopwatch();
//  List _pendingDisposedImages = <ui.Image>[];
//  Future<void> _createImage() async {
//    print(_pendingDisposedImages.length);
//    if (_canvasImage != null) {
//      _pendingDisposedImages.add(_canvasImage);
//    }
//    _canvasImage =
//        await _canvasPicture.toImage(size.width.toInt(), size.height.toInt());
//  }
//
//  void _disposePendingImages() {
//    _pendingDisposedImages.forEach((e) {
//      e.dispose();
//    });
//    _pendingDisposedImages.clear();
//  }

  void _createPicture() {
    final _recorder = ui.PictureRecorder();
    final _canvas = Canvas(_recorder);
    _stage.paint(_canvas);
    _canvasPicture = _recorder.endRecording();
//    _createImage();
  }

  /// The main `enterFrame`, called from the `SceneController` unique `GxTicker`.
  /// only valid when there's a GxTicker running.
  /// Manages the `update()` and can request redraw the CustomPainter.
  void tick(double time) {
    // makeCurrent();
    if (autoUpdateAndRender) {
      $currentFrameId++;
      $runTime += time;
      $update(time);
    }
    _onUpdate?.dispatch(time);
    $render();
    if (useOwnCanvas) {
      _ownCanvasNeedsRepaint = true;
//      _disposePendingImages();
    }
  }

  /// Update inner display list.
  void $update(double deltaTime) {
    if (maxFrameTime != -1 && deltaTime > maxFrameTime) {
      deltaTime = maxFrameTime;
    }
    $currentFrameDeltaTime = deltaTime;
    $accumulatedFrameDeltaTime += $currentFrameDeltaTime;

    /// TODO: make current GxTween.
    GTween.ticker.dispatch(deltaTime);
    // GxTween.update(deltaTime);
    _stage.$tick(deltaTime);

    _detectMouseMove();
  }

  /// temporal
  var _mouseMoveInputDetected = false;
  var _lastMouseX = -1000000.0;
  var _lastMouseY = -1000000.0;
  var _lastMouseOut = false;
  MouseInputData _lastMouseInput;

  void _detectMouseMove() {
    // If there was no mouse move dispatch a still event this handles static mouse OVER/OUT for moving/hiding objects
    if (!_mouseMoveInputDetected && _lastMouseX != -1000000) {
      final input = MouseInputData(
        target: _stage,
        dispatcher: _stage,
        type: MouseInputType.still,
      );
      input.localPosition.setTo(_lastMouseX, _lastMouseY);
      input.stagePosition.setTo(_lastMouseX, _lastMouseY);
      input.mouseOut = _lastMouseOut;
      if (_lastMouseInput != null) {
        input.buttonDown = _lastMouseInput.buttonDown;
        input.rawEvent = _lastMouseInput.rawEvent;
        input.buttonsFlags = _lastMouseInput.buttonsFlags;
      }
      _mouseInputHandler(input);
    }
    _mouseMoveInputDetected = false;
  }

  void _mouseInputHandler(MouseInputData input) {
    input.time = $accumulatedFrameDeltaTime;

    /// process it.
    if (input.type == MouseInputType.move) {
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

    /// process directly on stage.
    stage.captureMouseInput(input);
//    onMouseInput.dispatch(input);
  }

  /// Requests a new frame.
  void $render() {
//    makeCurrent();
    if (autoUpdateAndRender || needsRepaint) {
      requestRender();
    }
  }

  /// Direct way to ask painter invalidation.
  /// Can be called manually, without the need for a `tick()` event.
  /// Might be useful for repain the `CustomPainter` on keyboard on pointer
  /// signals.
  void requestRender() {
    notify();
  }

  bool shouldRepaint() => needsRepaint;

  @override
  void dispose() {
    _stage?.dispose();
//    core?.pointer?.onInput?.remove(_onInputHandler);
    _onUpdate?.removeAll();
    _onUpdate = null;
    super.dispose();
  }

  void _initMouseInput() {
    core?.pointer?.onInput?.add(_onInputHandler);
  }

  void _onInputHandler(PointerEventData e) {
    var event = MouseInputData(
      target: stage,
      dispatcher: stage,
      type: MouseInputData.fromNativeType(e.type),
    );
    event.rawEvent = e;
    event.buttonsFlags = e.rawEvent.buttons;
    event.buttonDown = e.rawEvent.down;
    event.localPosition.setTo(e.localX, e.localY);
    event.scrollDelta.setTo(e.scrollDelta?.dx ?? 0, e.scrollDelta?.dy ?? 0);
    event.stagePosition.setTo(e.stagePosition.x, e.stagePosition.y);
    _mouseInputHandler(event);
  }

  void makeCurrent() {
    ScenePainter.current = this;
  }

  void _pictureFromCanvas() {
    if (_ownCanvasNeedsRepaint) {
      _ownCanvasNeedsRepaint = false;
      _createPicture();
    }
//      if (_canvasImage != null) {
//        p_canvas.drawImage(_canvasImage, Offset.zero, PainterUtils.emptyPaint);
//      }
    if (_canvasPicture != null) {
      $canvas.drawPicture(_canvasPicture);
    }
  }
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
