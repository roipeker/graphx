import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:graphx/graphx/display/sprite.dart';
import 'package:graphx/graphx/scene_controller.dart';

import 'display/stage.dart';
import 'events/mixins.dart';
import 'events/pointer_data.dart';

class RootScene extends Sprite {
  ScenePainter owner;
  bool _ready = false;

  bool get isReady => _ready;

  @protected
  void init() {
    /// much like a constructor...
  }

  @protected
  @mustCallSuper
  void ready() {
    /// when stage is ready!
    _ready = true;
  }
}

class ScenePainter with EventDispatcherMixin {
  /// base for painter.
  SceneController core;
  RootScene root;

  /// allows to repaint on every tick()
  bool needsRepaint = false;

  ScenePainter(this.core, this.root) {
    _stage = Stage(this);
    root.owner = this;

    /// initialize pointer events.
  }

  CustomPainter buildPainter() => _GraphicsPainter(this);

  bool useOwnCanvas = false;

  Canvas $canvas;

  Size size = Size.zero;
  Stage _stage;

  Stage get stage => _stage;

  bool _isReady = false;

  bool get isReady => _isReady;

  bool _ownCanvasNeedsRepaint = false;

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
      root.ready();
    }
    if (useOwnCanvas) {
      if (_ownCanvasNeedsRepaint) {
        _ownCanvasNeedsRepaint = false;
        _createPicture();
      }
//      if (_canvasImage != null) {
//        p_canvas.drawImage(_canvasImage, Offset.zero, PainterUtils.emptyPaint);
//      }
      if (_canvasPicture != null) {
        p_canvas.drawPicture(_canvasPicture);
      }
    } else {
      _stage.paint($canvas);
    }
  }

  void setup() {
    root.init();
  }

  bool shouldRepaint() => needsRepaint;

  ui.Picture _canvasPicture;
  ui.Image _canvasImage;

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

  void tick() {
    if (useOwnCanvas) {
      _ownCanvasNeedsRepaint = true;
//      _disposePendingImages();
    }
    _stage.$tick();
    if (needsRepaint) {
      notify();
    }
  }

  /// direct way to ask invalidation.
  void requestRepaint() {
    notify();
  }

  @override
  void dispose() {
    _stage?.dispose();
    super.dispose();
  }

  void _initMouseInput() {
    core?.pointer?.onInput?.add(_onInputHandler);
  }

  void _onInputHandler(PointerEventData e) {
    stage.captureMouseInput(e);
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
