import 'package:flutter/material.dart';

import '../../graphx.dart';

class SceneConfig {
  /// If the GraphX SceneController will use keyboard events.
  bool useKeyboard;

  /// If this GraphX SceneController will use pointer (touch/mouse) events.
  bool usePointer;

  /// Will be overwritten to `true` if [autoUpdateAndRender] is set on any [ScenePainter] layer.
  /// Can be initialized on [SceneBuilderWidget()] or [ScenePainter::setupScene()].
  /// Warning: [setupScene()] takes priority over Widget initialization.
  bool useTicker;

  bool painterIsComplex;

  /// See [CustomPaint.]
  bool painterWillChange;

  /// Avoids the scene from being disposed by the Widget.
  /// Meant to be used with `ScenePainter.useOwnCanvas=true`
  /// where a Layer captures it's own drawing to be used as Picture or Image
  /// by other SceneLayers.
  /// Warning: Experimental
  bool isPersistent = false;

  SceneConfig({
    this.useKeyboard = false,
    this.usePointer = false,
    this.useTicker = false,
    this.isPersistent = false,
    this.painterIsComplex,
    this.painterWillChange,
  });

  void setTo({
    bool useTicker,
    bool useKeyboard,
    bool usePointer,
    bool sceneIsComplex,
  }) {
    if (useTicker != null) this.useTicker = useTicker;
    if (useKeyboard != null) this.useKeyboard = useKeyboard;
    if (usePointer != null) this.usePointer = usePointer;
    if (sceneIsComplex != null) painterIsComplex = sceneIsComplex;
  }

  void copyFrom(SceneConfig other) {
    useKeyboard = other.useKeyboard;
    usePointer = other.usePointer;
    useTicker = other.useTicker;
    painterIsComplex = other.painterIsComplex;
    painterWillChange = other.painterWillChange;
    isPersistent = other.isPersistent;
  }

  bool painterMightChange() {
    if (useTicker || usePointer || useKeyboard) {
      return true;
    }
    return painterWillChange ?? false;
  }
}

class SceneController {
  static SceneController current;

  ScenePainter back;
  ScenePainter front;

  GxTicker get ticker {
    if (_ticker == null) {
      throw 'You need to enable ticker usage with SceneBuilderWidget( useTicker=true ) or RootScene::setup(useTicker: true), or RootScene::setup(autoUpdateAndRender: true)';
    }
    return _ticker;
  }

  KeyboardManager get keyboard => _keyboard;

  PointerManager get pointer => _pointer;

  KeyboardManager _keyboard;
  PointerManager _pointer;
  GxTicker _ticker;

  InputConverter $inputConverter;

  SceneConfig get config => _config;
  final _config = SceneConfig();
  int id = -1;
  bool _isInited = false;

  void $init() {
    if (_isInited) return;
    setup();
    if (_hasTicker()) {
      _ticker = GxTicker();
      _ticker.onFrame.add(_onTick);
      if (_hasAutoUpdate()) {
        _ticker.resume();
      }
    }
    _initInput();
    _isInited = true;
  }

  void setup() {
    back?.$setup();
    front?.$setup();
  }

  Juggler get juggler => Graphx.juggler;

  /// [GxTicker] that runs the `enterFrame`.
  /// Is independent from the rendering pipeline.
  void _onTick(double elapsed) {
    Graphx.juggler.update(elapsed);
    // _makeCurrent();
//    _juggler.tick(elapsed);
//    print('elapsed:: $elapsed');
//    var ts = elapsed.inMilliseconds;
//    double diff = (ts - _lastElapsed) / 1000;
//    print("Elappsed!: $diff");
    front?.tick(elapsed);
    back?.tick(elapsed);
//    _lastElapsed = ts;
  }

  void _makeCurrent() {
    current = this;
  }

  void resumeTicker() {
    ticker?.resume();
  }

  void dispose() {
    if (_config.isPersistent) return;
    front?.dispose();
    back?.dispose();
    _ticker?.dispose();
    _ticker = null;
//    _ticker?.stop(canceled: true);
//    _ticker?.dispose();
//    _ticker = null;
  }

  CustomPainter buildBackPainter() => back?.buildPainter();

  CustomPainter buildFrontPainter() => front?.buildPainter();

  void _initInput() {
    if (_config.useKeyboard) {
//      _keyboardFocusNode = FocusNode();
      _keyboard ??= KeyboardManager();
    }
    if (_config.usePointer) {
      _pointer ??= PointerManager();
    }
    if (_config.useKeyboard || _config.usePointer) {
      $inputConverter ??= InputConverter(_pointer, _keyboard);
    }
  }

  SceneController._();

  static SceneController withLayers({SceneRoot back, SceneRoot front}) {
    assert(back != null || front != null);
    final controller = SceneController._();
    if (back != null) {
      controller.back = ScenePainter(controller, back);
    }
    if (front != null) {
      controller.front = ScenePainter(controller, front);
    }
    return controller;
  }

  bool _layerHasAutoUpdate(ScenePainter p) => p?.autoUpdateAndRender ?? false;

  bool _hasAutoUpdate() =>
      _layerHasAutoUpdate(back) || _layerHasAutoUpdate(front);

  bool _hasTicker() => _hasAutoUpdate() || _config.useTicker;
}
