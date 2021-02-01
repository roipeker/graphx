import 'package:flutter/material.dart';

import '../../graphx.dart';

/// Entry point of GraphX world.
/// A [SceneController] manages (up to) 2 [SceneRoot]s: `back` and `front`
/// which correlates to [CustomPainter.painter] and
/// [CustomPainter.foregroundPainter]. It takes care of the initialization
/// and holding the references of the Painters used by [SceneBuilderWidget].
class SceneController {
  /// This Signal will be dispatched when the Stateful Widget gets reassembled.
  /// Which usually means we are running the app in debug mode, and using
  /// hot-reload. If you run any logic during this rebuild phase, you can
  /// use this signal in any `DisplayObject` as long as it has access to the
  /// stage (.onAddedToStage).
  /// See also: [SceneConfig.rebuildOnHotReload] to set if this SceneController
  /// should rebuild itself on hot-reload.
  ///
  /// `stage.onHotReload.add((){
  ///   // your logic here
  ///  });`
  Signal _onHotReload;
  Signal get onHotReload => _onHotReload ??= Signal();

  ScenePainter backScene, frontScene;

  /// Access the `ticker` (if any) created by this SceneController.
  GTicker get ticker {
    if (_ticker == null) {
      throw 'You need to enable ticker usage with '
          'SceneBuilderWidget( useTicker=true ) or '
          'RootScene::setup(useTicker: true), or '
          'RootScene::setup(autoUpdateAndRender: true)';
    }
    return _ticker;
  }

  /// Access the keyboard manager instance associated with this
  /// [SceneController].
  KeyboardManager get keyboard => _keyboard;

  /// Access the pointer manager instance associated with this
  /// [SceneController].
  PointerManager get pointer => _pointer;

  KeyboardManager _keyboard;

  PointerManager _pointer;

  GTicker _ticker;

  InputConverter $inputConverter;

  SceneConfig get config => _config;

  final _config = SceneConfig();

  /// gets widget's global coordinates.
  /// useful to compute interactions with children Widgets that gets
  GRect Function() resolveWindowBounds;

  int id = -1;

  bool _isInited = false;

  set config(SceneConfig sceneConfig) {
    _config.rebuildOnHotReload = sceneConfig.rebuildOnHotReload ?? true;
    _config.autoUpdateRender = sceneConfig.autoUpdateRender ?? true;
    _config.isPersistent = sceneConfig.isPersistent ?? false;
    _config.painterWillChange = sceneConfig.painterWillChange ?? true;
    _config.useKeyboard = sceneConfig.useKeyboard ?? false;
    _config.usePointer = sceneConfig.usePointer ?? false;
    _config.useTicker = sceneConfig.useTicker ?? false;
  }

  /// constructor.
  SceneController({
    Sprite back,
    Sprite front,
    SceneConfig config,
  }) {
    assert(back != null || front != null);
    if (back != null) {
      backScene = ScenePainter(this, back);
    }
    if (front != null) {
      frontScene = ScenePainter(this, front);
    }
    this.config = config ?? SceneConfig.defaultConfig;
  }

  /// WARNING: Internal method
  /// called internally from [SceneBuilderWidget].
  void $init() {
    if (_isInited) {
      return;
    }
    setup();
    if (_hasTicker()) {
      _ticker = GTicker();
      _ticker.onFrame.add(_onTick);
      if (_anySceneAutoUpdate()) {
        _ticker.resume();
      }
    }
    _initInput();
    _isInited = true;
  }

  void setup() {
    backScene?.$setup();
    frontScene?.$setup();
  }

  /// [GTicker] that runs the `enterFrame`.
  /// Is independent from the rendering pipeline.
  void _onTick(double elapsed) {
    frontScene?.tick(elapsed);
    backScene?.tick(elapsed);
  }

  void resumeTicker() {
    ticker?.resume();
  }

  void dispose() {
    if (_config.isPersistent) {
      return;
    }
    _onHotReload?.removeAll();
    frontScene?.dispose();
    backScene?.dispose();
    _ticker?.dispose();
    _ticker = null;
    _isInited = false;
  }

  CustomPainter buildBackPainter() => backScene?.buildPainter();

  CustomPainter buildFrontPainter() => frontScene?.buildPainter();

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

  void reassembleWidget() {
    _onHotReload?.dispatch();
    if (_config.rebuildOnHotReload) {
      dispose();
      /// TODO: check if we need to delay the reinitialization.
      $init();
    }
  }

  bool _sceneAutoUpdate(ScenePainter scene) =>
      scene?.autoUpdateAndRender ?? false;

  bool _anySceneAutoUpdate() =>
      _sceneAutoUpdate(backScene) || _sceneAutoUpdate(frontScene);

  bool _hasTicker() => _anySceneAutoUpdate() || _config.useTicker;
}
