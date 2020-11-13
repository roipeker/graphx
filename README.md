<div align="center">
    <a>
        <h3>🎨</h3>
        <h1>GraphX™</h1>
    </a>

[![pub package](https://img.shields.io/pub/v/graphx.svg?label=graphx&color=blue)](https://pub.dev/packages/graphx)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

| rendering | prototype  | design  |



Making drawings and animations in Flutter extremely simple.


> *WARNING:* this lib is on alfa stage, the api can change.

> *NOTE:* GraphX™ uses the `$` prefix convention to all "internal/private" members (properties and methods). __DO NOT__ call them in your code... is meant to be consumed internally by the lib.
> until I cleanup and organize the code for an alpha version, then will probably moved all as part of the package. 
___


### wiki-tips.

To get some extended, boring explanations, and eventually some sample codes, check the [GraphX™ Wiki](https://github.com/roipeker/graphx/wiki/GraphX-tips-and-random%5BnextInt()%5D-stuffs.#graphx-general-tips) 

## background.

GraphX™ is here to help you build custom drawing in your Flutter apps. Providing an amazing versatility to power those screen pixels to a different level.

It's inspired by the good-old Flash API, which forged my way into programming back in the days, and also shaped many other rendering frameworks in several languages through the years.

I was thinking how much I missed to "play" with code, to make things more organic, artistic, alive... I totally love Flutter,  but I always feel that it requires too much boilerplate to make things move around (compared to what I used to code).

Even if GraphX™ is not a tween or physics engine (in fact it doesn't even have one, yet), it runs on top of CustomPainter, it uses what Flutter SDK exposes from the SKIA engine, through the Canvas, but gives you a "framework" to isolate yourself from the Widget world.

It can be used to simple draw a line, a circle, a custom button, some splash effect on your UI, or even a full blown game in a portion of you screen. Mix and match with Flutter as you please, as GraphX™ uses CustomPainter, is part of your widget tree.


So, let your imagination fly.    
   
## concept.

<div align="left">
This repo is just a very early WIP to put something online... 
still lacks support for loading remote images, 2.5D and some other nicities.

Yet, we have some super basic support for loading rootBundle assets!
```dart
AssetLoader.loadImageTexture(assetId)  
AssetLoader.loadString(assetId)  
AssetLoader.loadJson(assetId)  
```

And some basic "raw" support for Text rendering with the `StaticText` class.
</div>




-----------

GraphX™ drives a CustomPainter inside, the idea is to simplify the usage of Flutter's `Canvas`, plus adding the DisplayList concept, so you can manage and create more complex "scenes".

GraphX™ has it's own rendering cycle (no AnimationController), and input capture, even if it runs on the Widget tree, you can enable the flags to capture mouse/touch input (through the `stage.pointer`), or keystrokes events (if u wanna do some simple game).
   
### sample code.

<div align="left">

```dart
  body: Center(
    child: SceneBuilderWidget( /// wrap any Widget with SceneBuilderWidget
      useKeyboard: false, /// define the capabilities
      usePointer: true,
      builder: () => SceneController.withLayers(
        back: GameSceneBack(), /// optional provide the background layer
        front: GameSceneFront(), /// optional provide the foreground layer
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'You have pushed the button this many times:',
          ),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    ),
  ),
```

GraphX™ is based on "Scenes" layers, 
each `SceneBuilderWidget` requires a `SceneController`. This controller is the "initializer" of the Scenes Layers, which can be:
 - `back` (background painter), 
 - `front` (foreground painter), 
 - or both.

Each "Scene Layer" has to extend `SceneRoot`, it represents the starting point of that particular scene hierarchy. Think of it as `MaterialApp` widget is to all other children Widgets in the tree.  

Here we get into **GraphX™** world, no more Widgets Trees or immutable properties.

You can override `init()` to setup things needed for this current Scene Painter object, like if it needs keyboard/mouse/touch access, or if it requires a `Ticker` and redraw the CustomPainter, cause it will animate.

Override `ready()` as your entry point, here the engine is set up, and the glorified `Stage` is available to use.

```dart
class GameScene extends SceneRoot {
  GameScene(){
    config(autoUpdateAndRender: true, usePointer: true);
  }

  @override
  void addedToStage() {
    /// if you have to stop the Ticker. Will stop all
    /// Tweens, Jugglers objects in GraphX.
    stage.scene.core.ticker.pause();
  }
```

For now, GraphX™ has a couple of classes for rendering the display list:
`Shape` and `Sprite` ( which are `DisplayObject`, `DisplayObjectContainer` are _abstracts_),

They both have a `graphics` property which is of type `Graphics` and provides a simplistic API to paint on the Flutter's `Canvas`.

By the way, `SceneRoot` is a Sprite as well!, and it's your `root` node in the display tree, kinda where all starts to render, and where you need to add your own objects.

For instance, to create a simple purple circle:

```dart
@override
void addedToStage(){
    var circle = Shape();
    circle.graphics.lineStyle(2, Colors.purple.value) /// access hex value of Color
      ..drawCircle(0, 0, 20)
      ..endFill();
    addChild(circle); // add the child to the rootScene.
}
```

`SceneRoot` is a `Sprite` (which is a `DisplayObjectContainer`) and can have children inside, yet `Shape` is a `DisplayObject`, and can't have children. But it makes it a little bit more performant on each painter step.

We could also use our root scene to draw things:

```dart
@override
addedToStage(){
  graphics.beginFill(0x0000ff, .6)
  ..drawRoundRect(100, 100, 40, 40, 4)
  ..endFill();
...
}
```

Scene setup sample in your `SceneRoot` (in your constructor):
```dart
config(
  autoUpdateAndRender: true,
  usePointer: true,
  useTicker: true,
  useKeyboard: false,
  sceneIsComplex: true,
);
```

Pointer signals has been "simplified" as Mouse events now... as it's super easy to work with single touch / mouse interactions in `DisplayObject`s.
There're a bunch of signals to listen on each element... taken from AS3, and JS.
- onMouseDoubleClick
- onMouseClick
- onMouseDown
- onMouseUp
- onMouseMove
- onMouseOver
- onMouseOut
- onMouseScroll

They all emit a `MouseInputData` with all the needed info inside, like stage coordinates, or translated local coordinates, which "mouse" button is pressed, etc.

------

*I will keep adding further explanation in the upcoming days.* 

### demos.

_Some demos are only using **GraphX™** partially, and might have big CPU impact_

[Flutter widget mix](http://roi-graphx-widgetmix.surge.sh)

[Split RGB](http://roi-graphx-rgbsplit.surge.sh)

[Input Text particles](http://roi-graphx-particles-input.surge.sh)

[FishEye particles](http://roi-graphx-fisheyeparticles.surge.sh/)

[FishEye particles (basic)](http://roi-graphx-fisheyetext.surge.sh)

[Particles emitter](http://roi-graphx-particles2.surge.sh)

[ShapeMaker clone](http://roi-graphx-shapemaker.surge.sh)

[Mouse follower](http://roi-graphx-dotchain.surge.sh)

[basic hit test](http://roi-graphx-hittest.surge.sh)

[SpriteSheet rendering](http://roi-graphx-spritesheet.surge.sh)

[DisplayObject Pivot](http://roi-graphx-textpivot.surge.sh)

[Simple solo-ping-pong game](http://roi-graphx-pingpong.surge.sh/)

[First Experimentation with rendering](http://roi-graphx-cells.surge.sh/)


----


Feel free to play around with the current API, even if it's still rough on edges and unoptimized, it might help you do things quicker.  

SKIA is pretty powerful!
</div>
-------------

#### Donation
You can [buymeacoffee](https://www.buymeacoffee.com/roipeker) or support **GraphX™** via [Paypal](https://www.paypal.me/roipeker/)

[![Donate via PayPal](https://cdn.rawgit.com/twolfson/paypal-github-button/1.0.0/dist/button.svg)](https://www.paypal.me/roipeker/)

[![Support via buymeacoffee](https://cdn.buymeacoffee.com/buttons/v2/default-white.png)](https://www.buymeacoffee.com/roipeker)
-------------

Resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
