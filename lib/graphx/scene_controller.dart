import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:graphx/graphx/input/keyboard_manager.dart';
import 'package:graphx/graphx/input/pointer_manager.dart';
import 'package:graphx/graphx/scene_painter.dart';

import 'input_converter.dart';

class SceneConfig {
  bool useKeyboard;
  bool usePointer;
  bool useTicker;
  bool painterIsComplex;
  bool painterWillChange;

  bool isPersistent;

  SceneConfig({
    this.useKeyboard = false,
    this.usePointer = false,
    this.useTicker = true,
    this.painterIsComplex = false,
    this.painterWillChange = true,
    this.isPersistent = false,
  });

  void copyFrom(SceneConfig other) {
    useKeyboard = other.useKeyboard;
    usePointer = other.usePointer;
    useTicker = other.useTicker;
    painterIsComplex = other.painterIsComplex;
    painterWillChange = other.painterWillChange;
    isPersistent = other.isPersistent;
  }
}

class SceneController {
  static SceneController current;

  ScenePainter back;
  ScenePainter front;
  Ticker _ticker;

  KeyboardManager get keyboard => _keyboard;

  PointerManager get pointer => _pointer;
  KeyboardManager _keyboard;
  PointerManager _pointer;

  InputConverter $inputConverter;

  SceneConfig get config => _config;
  SceneConfig _config = SceneConfig();
  int id = -1;
  bool _isInited = false;

  void $init() {
    if (_isInited) return;
    setup();
    if (_config.useTicker) {
      _createTicker();
    }
    _initInput();
    _isInited = true;
  }

  void setup() {
    back?.setup();
    front?.setup();
  }

  void _onTick(Duration elapsed) {
    front?.tick();
    back?.tick();
  }

  void dispose() {
    if (_config.isPersistent) return;
    front?.dispose();
    back?.dispose();
    _ticker?.stop(canceled: true);
    _ticker?.dispose();
    _ticker = null;
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

  static SceneController withLayers({RootScene back, RootScene front}) {
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

  void _createTicker() {
    if (_ticker != null) return;
    _ticker = Ticker(_onTick);
    _ticker.start();
    _ticker.muted = true;
  }

  bool get isTicking => _ticker?.isTicking;

  bool get isActive => _ticker?.isActive;

  void resumeTicker() {
    /// create if it doesnt exists.
    _createTicker();
    _ticker?.muted = false;
  }

  void pauseTicker() {
    _ticker?.muted = true;
  }
}
