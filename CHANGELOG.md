## [0.9.6]
- Improved docs.
- Removed animations.dart, GTween is used in favor of Juggler.
- Changed [GameUtils] to [Math], class to keep consistency with ActionScript/JS API.
- Improved gradient support in `Graphics`. For the sake of representing all the options for different Gradient Shaders in GraphX, uncommon positional parameters where replaced by named parameters for `lineGradientStyle()` and `beginGradientFill()`.
- Fixed a bug with [StaticText.width] when using by default `double.infinity`, unsupported in Flutter web non-SKIA target.
- Minor bugfixes.
- Added package `http` and `flutter_svg` dependencies to facilitate some GraphX features.
- Added [SvgUtils] with basic methods to work with svg data.
- Renamed [AssetsLoader] to [ResourceLoader], and moved to the `io` namespace; to avoid confusion with Flutter concepts where asset reference a local resource.
- Added [NetworkImageLoader] class, to provide the ability to load remote images. Can be used with [ResourceLoader.loadNetworkTexture] and [ResourceLoader.loadNetworkSvg]. WARNING: no CORS workaround for web targets.
- Added cache capabilities to network images, and some new methods on [ResourceLoader]: loadNetworkSvg(), loadNetworkTexture(), loadSvg(), getSvgData().
- Added [StaticText.build()] to simplify the initialization and styling of [StaticText].
- Added [Keyboard], utility class to simplify interactions with `stage.keyboard` during `update()` phase [stage.onEnterFrame].


## [0.9.5]
- Fixes `DisplayObject.visible` not being updated on rendering.
- Added `display object.setProps()` as a shortcut to assign basic properties using GTween and immediate render.
- Added `GlowFilter`, `DropShadowFilter` and `ColorMatrixFilter`.
- Added `GTween` extension support to filters, can easily create tweens like:
  ```dart
  var glow = GlowFilter(4, 4, Colors.blue);
  box.filters = [glow];
  stage.onMouseDown.add((event) {
  glow.tween(duration: .3, blurX: 12, color: Colors.green);
  });
  stage.onMouseUp.add((event) {
  glow.tween(duration: .3, blurX: 4, color: Colors.blue);
  });
  ```
- Added `SystemUtils.usingSkia` to restrict unsoported operations in regular Flutter web.
- Fixed `GTween.overwrite=1` so it finds the proper target object.

## [0.9.4]
- fixes TextureAtlas XML parsing (some formarts were not readed properly).
- added support for hot-reload: Now you can use `SceneConfig.rebuildOnHotReload` and `stage.onHotReload` to manage your own logic.
- fixed some issues with dispose() not cleaning up vars (useful for hotReload).
- added SceneController access to the stage (`stage.controller`).
- Basic support for Flutter Web (no SKIA target needed!), will have to check all the APIs. New `SystemUtils.usingSkia` to check the compilation.

## [0.9.2] - [0.9.3]
- added `SceneController::resolveWindowsBounds()` to get a GxRect in global coordinates, to calculate the screen offsets between GraphX scenes and other Widgets at different locations in the Widget tree.
- StaticText now listens to systemFonts, to detect when fonts loaded at runtime (useful when using GoogleFonts package).

## [0.9.1]
- GxIcon recreates `ParagraphBuilder` on each style change (otherwise throws an exception in latest builds with web-skia in dev channel).
- each DisplayObject has its own Painter now for `saveLayer`, the bounding rect can't be skipped by `$useSaveLayerBounds=true`.

## [0.9.0]
- GraphX moves to RC1!
- new `maskRect` and `maskRectInverted` as an alternative to `mask` for masking DisplayObjects but makes scissor clipping with `GxRect`.
- added `GxMatrix.clone()`
- added `GTween.timeScale` to have a global control over tween times and delays.
- added `Graphics.beginBitmapFill` and `Graphics.lineBitmapStyle` to Graphics, now you can fill shapes with Images!
- improved `Graphics.beginGradientFill` for `GradientType.radial`... now you can specify the `radius` for it. 
- added support `Graphics.drawTriangles()`, (uses  `Canvas.drawVertices()`), to create potentially 3d shapes. Supports solid fills: image, gradient, and color, but no strokes (`lineStyle`).
- flipped CHANGELOG.md versions direction. 
- more code cleanup and updated README.md!

## [0.0.1+9]
- readme fix.
 
## [0.0.1+8]
- big refactor to initialize SceneController(), now it takes the [SceneConfig] from the constructor (`withLayers()` was removed).
- cleanup docs to reflect the change.
- no more [SceneRoot], now you can use [Sprite] directly as the root layer Scene!

## [0.0.1+7]
- fix for mouse exit event not being detected when the scene is way too small and the pointer event happens too fast over the target.
- an improved README.md

## [0.0.1+6]
- exported back graphics_clipper
- added experimental startDrag()/stopDrag() methods.

## [0.0.1+5]
- added missing export in graphx.
- testing discord integration.
- GTween changed VoidCallback to Function to avoid linting errors.

## [0.0.1+4]
- code clean up and minor fixes in the readme.
- adds `trace()` global function, as an option to `print()`. It allows you to pass up to 10 arguments, 
and configure stack information to show through `traceConfig()`. So it can print _caller_ name (method name), 
_caller object_ (instance / class name where caller is), filename and line number with some custom format.

## [0.0.1+3]
- Another improve to the README.md, gifs have links to videos, to check screencasts in better quality.
- Added help & social links.
- cleanup more code.

## [0.0.1+2]
- Improved README.md with gif screencast samples.
- cleanup some code.

## [0.0.1]	
- Initial release.
