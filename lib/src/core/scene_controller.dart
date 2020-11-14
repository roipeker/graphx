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

  /// Quick method to set the object properties.
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

  /// Copy the values from another [SceneConfig] instance.
  void copyFrom(SceneConfig other) {
    useKeyboard = other.useKeyboard;
    usePointer = other.usePointer;
    useTicker = other.useTicker;
    painterIsComplex = other.painterIsComplex;
    painterWillChange = other.painterWillChange;
    isPersistent = other.isPersistent;
  }

  /// Utility method used by the [SceneBuilderWidget] to set the flag
  /// `CustomPaint.willChange`
  bool painterMightChange() {
    if (useTicker || usePointer || useKeyboard) {
      return true;
    }
    return painterWillChange ?? false;
  }
}

/// Entry point of GraphX world.
/// A [SceneController] manages (up to) 2 [SceneRoot]s: `back` and `front`
/// which correlates to [CustomPainter.painter] and [CustomPainter.foregroundPainter]
/// It takes care of the initialization and holding the references of the Painters
/// used by [SceneBuilderWidget].
class SceneController {
  /// Eventually, might be a global access point to the current rendering
  /// Scene, it should be in sync with the repainting process, so is safe
  /// to assume that it will point to the proper SceneController reference.
  // static SceneController current;

  ScenePainter back;
  ScenePainter front;

  /// Access the `ticker` (if any) created by this SceneController.
  GxTicker get ticker {
    if (_ticker == null) {
      throw 'You need to enable ticker usage with SceneBuilderWidget( useTicker=true ) or RootScene::setup(useTicker: true), or RootScene::setup(autoUpdateAndRender: true)';
    }
    return _ticker;
  }

  /// Access the keyboard manager instance associated with this [SceneController].
  KeyboardManager get keyboard => _keyboard;

  /// Access the pointer manager instance associated with this [SceneController].
  PointerManager get pointer => _pointer;

  KeyboardManager _keyboard;
  PointerManager _pointer;
  GxTicker _ticker;

  InputConverter $inputConverter;

  SceneConfig get config => _config;
  final _config = SceneConfig();
  int id = -1;
  bool _isInited = false;

  /// WARNING: Internal method
  /// starts from the `SceneBuilderWidget`.
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
    front?.tick(elapsed);
    back?.tick(elapsed);
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
  }

  CustomPainter buildBackPainter() => back?.buildPainter();

  CustomPainter buildFrontPainter() => front?.buildPainter();

  void _initInput() {
    if (_config.useKeyboard) {
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
