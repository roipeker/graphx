import 'package:flutter/material.dart';

import '../../graphx.dart';

/// A function that returns the global coordinates of the widget.
typedef WindowBoundsResolver = GRect? Function();

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
  Signal? _onHotReload;

  /// The [ScenePainter] for the back layer of this [SceneController].
  ScenePainter? backScene;

  /// The [ScenePainter] for the front layer of this SceneController.
  ScenePainter? frontScene;

  /// The [KeyboardManager] instance associated with this SceneController.
  late KeyboardManager _keyboard;

  /// The [PointerManager] instance associated with this SceneController.
  late PointerManager _pointer;

  /// The [GTicker] instance associated with this SceneController.
  GTicker? _ticker;

  /// (Internal usage)
  /// The [InputConverter] instance associated with this SceneController.
  late InputConverter $inputConverter;

  /// The configuration object for the Scene.
  final _config = SceneConfig();

  /// A function that returns the global coordinates of the widget.
  /// Useful for computing interactions with children Widgets that get added
  /// later.
  WindowBoundsResolver? resolveWindowBounds;

  /// Flag to track whether the Scene is initialized.
  bool _isInited = false;

  /// The [SceneController] constructor.
  ///
  /// The optional [back] and [front] arguments specify the background and
  /// foreground [GSprite] objects, respectively. The optional [config]
  /// argument specifies the configuration for this [SceneController].
  SceneController({
    GSprite? back,
    GSprite? front,
    SceneConfig? config,
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

  /// The [SceneConfig] instance associated with this SceneController.
  SceneConfig get config => _config;

  set config(SceneConfig sceneConfig) {
    _config.rebuildOnHotReload = sceneConfig.rebuildOnHotReload;
    _config.autoUpdateRender = sceneConfig.autoUpdateRender;
    _config.isPersistent = sceneConfig.isPersistent;
    _config.painterWillChange = sceneConfig.painterWillChange;
    _config.useKeyboard = sceneConfig.useKeyboard;
    _config.usePointer = sceneConfig.usePointer;
    _config.useTicker = sceneConfig.useTicker;
  }

  /// Access the keyboard manager instance associated with this
  /// [SceneController].
  KeyboardManager get keyboard => _keyboard;

  /// The [Signal] that is dispatched when the Stateful Widget gets reassembled.
  Signal get onHotReload => _onHotReload ??= Signal();

  /// Access the pointer manager instance associated with this
  /// [SceneController].
  PointerManager get pointer => _pointer;

  /// Access the `ticker` (if any) created by this SceneController.
  GTicker? get ticker {
    if (_ticker == null) {
      throw 'You need to enable ticker usage with '
          'SceneBuilderWidget( useTicker=true ) or '
          'RootScene::setup(useTicker: true), or '
          'RootScene::setup(autoUpdateAndRender: true)';
    }
    return _ticker;
  }

  /// (Internal usage)
  /// called internally from [SceneBuilderWidget].
  void $init() {
    if (_isInited) {
      return;
    }
    setup();
    if (_hasTicker()) {
      _ticker = GTicker();
      _ticker!.onFrame.add(_onTick);
      if (_anySceneAutoUpdate()) {
        _ticker!.resume();
      }
    }
    _initInput();
    _isInited = true;
  }

  /// Builds the back [CustomPainter] associated with this [SceneController].
  CustomPainter? buildBackPainter() => backScene?.buildPainter();

  /// Builds the front [CustomPainter] associated with this [SceneController].
  CustomPainter? buildFrontPainter() => frontScene?.buildPainter();

  /// Disposes of this [SceneController].
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

  /// (Internal usage)
  /// Called when the Stateful Widget gets reassembled.
  void reassembleWidget() {
    _onHotReload?.dispatch();
    if (_config.rebuildOnHotReload) {
      GTween.hotReload();
      dispose();

      /// TODO: check if we need to delay the reinitialization.
      $init();
    }
  }

  /// Resumes the [GTicker].
  void resumeTicker() {
    ticker?.resume();
  }

  /// Initializes the [SceneController].
  void setup() {
    if (!GTween.initializedCommonWraps) {
      /// you can add your own `CustomTween.wrap()` registering.
      GTween.registerCommonWraps([
        GTweenableBlur.wrap,
        GTweenableDropShadowFilter.wrap,
        GTweenableGlowFilter.wrap,
      ]);
    }
    backScene?.$setup();
    frontScene?.$setup();
  }

  /// Returns `true` if either the back or front [ScenePainter] is set to
  /// auto-update and render.
  bool _anySceneAutoUpdate() =>
      _sceneAutoUpdate(backScene) || _sceneAutoUpdate(frontScene);

  /// Returns `true` if either the back or front [ScenePainter] is set to
  /// auto-update and render, or if the ticker is being used.
  bool _hasTicker() => _anySceneAutoUpdate() || _config.useTicker;

  /// Initializes the input manager for this [SceneController].
  void _initInput() {
    // if (_config.useKeyboard) {
    //   _keyboard ??= KeyboardManager();
    // }
    // if (_config.usePointer) {
    //   _pointer ??= PointerManager();
    // }

    _keyboard = KeyboardManager();
    _pointer = PointerManager();
    // if (_config.useKeyboard ?? false || (_config.usePointer ?? false)) {
    //   trace("CREATE INPUT!");
    // }
    $inputConverter = InputConverter(_pointer, _keyboard);
  }

  /// The function that is called on each frame of the [GTicker].
  /// [GTicker] that runs the `enterFrame`.
  /// Is independent from the rendering pipeline.
  void _onTick(double elapsed) {
    GTween.processTick(elapsed);
    frontScene?.tick(elapsed);
    backScene?.tick(elapsed);
  }

  /// Returns `true` if either the back or front [ScenePainter] is set to
  /// auto-update and render.
  bool _sceneAutoUpdate(ScenePainter? scene) =>
      scene?.autoUpdateAndRender ?? false;
}
