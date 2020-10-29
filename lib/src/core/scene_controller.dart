
import 'package:flutter/material.dart';

import '../../graphx.dart';


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
  GxTicker ticker;

//  Ticker _ticker;

  KeyboardManager get keyboard => _keyboard;

  PointerManager get pointer => _pointer;
  KeyboardManager _keyboard;
  PointerManager _pointer;

  InputConverter $inputConverter;

  SceneConfig get config => _config;
  final  _config = SceneConfig();
  int id = -1;
  bool _isInited = false;

  void $init() {
    if (_isInited) return;
    setup();
    ticker = GxTicker();
    if (_config.useTicker) {
      // ticker.resume();
      ticker.onFrame.add(_onTick);
    }
    _initInput();
    _isInited = true;
  }

  void setup() {
    back?.setup();
    front?.setup();
  }

  /// process timeframe
//  int _lastElapsed = 0;
  Juggler get juggler => Graphx.juggler;

  /// enterframe ticker
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
    ticker.dispose();
    ticker = null;
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
}
