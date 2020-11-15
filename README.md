<div align="center">
    <a>
        <h3>🎨</h3>
        <h1>GraphX™</h1>
    </a>

[![pub package](https://img.shields.io/pub/v/graphx.svg?logo=data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjQiIGhlaWdodD0iNjQiIHZpZXdCb3g9IjAgMCA2NCA2NCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGcgY2xpcC1wYXRoPSJ1cmwoI2NsaXAwKSI+CjxwYXRoIGQ9Ik0xNiAtMS4zOTg3NmUtMDZMNDggMEw0OCAyNS41OTM4TDQxLjU5MzcgMjUuNTkzN0w0MS41OTM3IDYuMzk4NDRMMjIuMzk4NCA2LjM5ODQ0TDIyLjM5ODQgMTkuMTk1M0wyOC43OTY5IDE5LjE5NTNMMjguNzk2OSAxMi43OTY5TDM1LjE5NTMgMTIuNzk2OUwzNS4xOTUzIDI1LjU5MzdMMTYgMjUuNTkzN0wxNiAtMS4zOTg3NmUtMDZaIiBmaWxsPSIjNDBDNEZGIi8+CjxwYXRoIGQ9Ik0xNiAzMkwyMi4zOTg0IDMyTDIyLjM5ODQgMzguMzk4NEwxNiAzOC4zOTg0TDE2IDMyWk0xNiA1Ny41OTM3TDIyLjM5ODQgNTcuNTkzN0wyMi4zOTg0IDY0TDE2IDY0TDE2IDU3LjU5MzdaTTIyLjM5ODQgMzguMzk4NEwyOC43OTY5IDM4LjM5ODRMMjguNzk2OSA0NC43OTY5TDIyLjM5ODQgNDQuNzk2OUwyMi4zOTg0IDM4LjM5ODRaTTIyLjM5ODQgNTEuMTk1M0wyOC43OTY5IDUxLjE5NTNMMjguNzk2OSA1Ny41OTM3TDIyLjM5ODQgNTcuNTkzN0wyMi4zOTg0IDUxLjE5NTNaTTI4Ljc5NjkgNDQuNzk2OUwzNS4xOTUzIDQ0Ljc5NjlMMzUuMTk1MyA1MS4xOTUzTDI4Ljc5NjkgNTEuMTk1M0wyOC43OTY5IDQ0Ljc5NjlaTTM1LjE5NTMgMzguMzk4NEw0MS41OTM3IDM4LjM5ODRMNDEuNTkzNyA0NC43OTY5TDM1LjE5NTMgNDQuNzk2OUwzNS4xOTUzIDM4LjM5ODRaTTM1LjE5NTMgNTEuMTk1M0w0MS41OTM3IDUxLjE5NTNMNDEuNTkzNyA1Ny41OTM3TDM1LjE5NTMgNTcuNTkzN0wzNS4xOTUzIDUxLjE5NTNaTTQxLjU5MzggMzJMNDggMzJMNDggMzguMzk4NEw0MS41OTM3IDM4LjM5ODRMNDEuNTkzOCAzMlpNNDEuNTkzNyA1Ny41OTM3TDQ4IDU3LjU5MzhMNDggNjRMNDEuNTkzNyA2NEw0MS41OTM3IDU3LjU5MzdaIiBmaWxsPSIjMjlCNkY2Ii8+CjwvZz4KPGRlZnM+CjxjbGlwUGF0aCBpZD0iY2xpcDAiPgo8cmVjdCB3aWR0aD0iNjQiIGhlaWdodD0iNjQiIGZpbGw9IndoaXRlIi8+CjwvY2xpcFBhdGg+CjwvZGVmcz4KPC9zdmc+Cg==&label=graphx&style=for-the-badge&color=blue)](https://pub.dev/packages/graphx)
[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg?style=for-the-badge&color=blue)](https://pub.dev/packages/effective_dart)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge&color=blue)](https://opensource.org/licenses/MIT)


| rendering | prototype  | design  |

Making drawings and animations in Flutter extremely simple.

___
 *WARNING:* this lib is on alpha stage, the api can change.

 *NOTE:* **GraphX**™ uses the `$` prefix convention for all internal and private members (properties and methods). __DO NOT__ call them in your code... is meant to be consumed internally by the lib,
it will remain as it is, at least initially, while the package takes shape. 
___

### wiki-tips.

To get some extended, boring explanations, and eventually some sample codes, check the [GraphX™ Wiki](https://github.com/roipeker/graphx/wiki/GraphX-tips-and-random%5BnextInt()%5D-stuffs.#graphx-general-tips) 
___

#### prototyping 

As graphx is about visuals, here you have some screen captures of random prototypes I've been doing, while developing and testing graphx. 

[![artificial horizon](https://media.giphy.com/media/NMG8gfpJxFiu1eALZo/giphy.gif)](https://media.giphy.com/media/NMG8gfpJxFiu1eALZo/source.mp4)
[![parallax game](https://media.giphy.com/media/RIrvhfZoDtal41Tb4e/giphy-downsized.gif)](https://media.giphy.com/media/RIrvhfZoDtal41Tb4e/source.mp4)
[![charts pie color 2](https://media.giphy.com/media/pQdeurUOAqWdZuxxUK/giphy.gif)](https://media.giphy.com/media/pQdeurUOAqWdZuxxUK/source.mp4)
[![simple particles](https://media.giphy.com/media/VYSJF6uUO323FV0Nhh/giphy.gif)](https://media.giphy.com/media/WodwBEccmRjmhq2dAp/source.mp4)
[![drawing api playful v1](https://media.giphy.com/media/HdJmgzVYLK8jUxX437/giphy.gif)](https://media.giphy.com/media/HdJmgzVYLK8jUxX437/source.mp4)


... jump to [other gifs samples](#screencast-demos) ...

<div align="left">
    
    
## Background.


GraphX™ is here to help you build custom drawings in your Flutter apps. Providing a great versatility to power those screen pixels to a different level.

It's inspired by the good-old Flash API, which forged my way into programming back in the days, and inspired many other rendering frameworks, in several languages through the years.

I was thinking how much I missed to "play" with code, to make things more organic, artistic, alive... I totally love Flutter,  but I always feel that it requires too much boilerplate to make things move around (compared to what I used to code).

Even if GraphX™ is not an animation library (although has a small tween engine), nor a game engine, It can help you build really awesome user experiences! It just runs on top of `CustomPainter`... Using what Flutter SDK exposes from the SKIA engine through the Canvas, yet, gives you some "framework" to run `isolated` from the Widget's world.

Can be used to simple draw a line, a circle, maybe a custom button, some splash effect on your UI, or even a full-blown game in a portion of the screen. 

Mix and match with Flutter as you please, as **GraphX**™ uses `CustomPainter`, it is part of your Widget's tree.    
   
## Concept.

This repo is a very early WIP ... the library still lacks of support for loading remote assets, 2.5 transformation and some other niceties.

Yet, it has a ver basic support for loading `rootBundle` assets:
```dart
AssetLoader.loadBinary(assetId)  
AssetLoader.loadGif(assetId)  
AssetLoader.loadTextureAtlas(imagePath, xmlPath)  
AssetLoader.loadTexture(assetId)  
AssetLoader.loadImage(assetId)  
AssetLoader.loadString(assetId)  
AssetLoader.loadJson(assetId)  
```

GraphX™ also provides basic "raw" support for Text rendering, using the `StaticText` class.

-----------

How does it work?

GraphX™ drives a `CustomPainter` inside. The idea is to simplify the usage of Flutter's `Canvas`, plus adding the **display list** concept, very similar to the Widget Tree concept; so you can imperatively code, manage and create more complex "Scenes".

The library has its own rendering cycle using Flutter's `Ticker` (pretty much like `AnimationController` does), and each `SceneWidgetBuilder` does its own input capture and processing (mouse, keyboard, touches). Even if it runs on the Widget tree, you can enable the flags to capture mouse/touch input, or keystrokes events (if u wanna do some simple game, or desktop/web tool).
   
### Sample code.

```dart
  body: Center(
    child: SceneBuilderWidget( /// wrap any Widget with SceneBuilderWidget
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

GraphX™ is based on "Scenes" layers, each `SceneBuilderWidget` requires a `SceneController`. 
This controller is the "initializer" of the Scenes layers, which can be:

 - `back` (background painter), 
 - `front` (foreground painter), 
 - or both.

Each "Scene Layer" has to extend `SceneRoot`, which represents the starting point of that particular scene hierarchy. Think of it as `MaterialApp` widget is to all other children Widgets in the tree.  

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

### Demos.

_Some demos are only using **GraphX™** partially, and might have big CPU impact_

[Flutter widget mix](https://roi-graphx-widgetmix.surge.sh)

[Split RGB](https://roi-graphx-rgbsplit.surge.sh)

[Input Text particles](https://roi-graphx-particles-input.surge.sh)

[FishEye particles](https://roi-graphx-fisheyeparticles.surge.sh/)

[FishEye particles (basic)](https://roi-graphx-fisheyetext.surge.sh)

[Particles emitter](https://roi-graphx-particles2.surge.sh)

[ShapeMaker clone](https://roi-graphx-shapemaker.surge.sh)

[Mouse follower](https://roi-graphx-dotchain.surge.sh)

[basic hit test](https://roi-graphx-hittest.surge.sh)

[SpriteSheet rendering](https://roi-graphx-spritesheet.surge.sh)

[DisplayObject Pivot](https://roi-graphx-textpivot.surge.sh)

[Simple solo-ping-pong game](https://roi-graphx-pingpong.surge.sh/)

[First Experimentation with rendering](https://roi-graphx-cells.surge.sh/)


----


Feel free to play around with the current API, even if it's still rough on edges and unoptimized, it might help you do things quicker.  

SKIA is pretty powerful!
</div>

-------------

### help & socialize.


| **Discord**                                                                                                                 | **Telegram**                                                                                                          |
| :-------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------- |
| [![Discord Shield](https://img.shields.io/discord/777232130991718440.svg?style=for-the-badge&logo=discord)](https://discord.com/invite/ed5szwuK) | [![Telegram](https://img.shields.io/badge/chat-on%20Telegram-blue.svg?style=for-the-badge&logo=telegram)](https://t.me/joinchat/Mbc7jBxxAm4K1uhaVPIR-Q)|

---

### Screencast Demos.

(Some demos uses GraphX's only for ticker, input events or initial scene graph, making usage of
direct `Canvas` calls)._

[![charts bezier + gradient](https://media.giphy.com/media/QWHufIK9GyEAIM4Dcn/giphy.gif)](https://media.giphy.com/media/QWHufIK9GyEAIM4Dcn/source.mp4)
[![svg sample demo](https://media.giphy.com/media/OtGpmd1fAVzw3pK7kD/giphy.gif)](https://media.giphy.com/media/wLuFm9xlXXmkllWJQt/source.mp4)
[![charts lines](https://media.giphy.com/media/uVFvFOTUICAsYqb13r/giphy.gif)](https://media.giphy.com/media/uVFvFOTUICAsYqb13r/source.mp4)
[![charts pie color 1](https://media.giphy.com/media/z1aIQzYSSGVKeWbabJ/giphy.gif)](https://media.giphy.com/media/z1aIQzYSSGVKeWbabJ/source.mp4)
[![mouse cursor support](https://media.giphy.com/media/MjXTKJpen8vIN34rfW/giphy.gif)](https://media.giphy.com/media/MjXTKJpen8vIN34rfW/source.mp4)
[![debug objects bounds](https://media.giphy.com/media/F7Wnsw3kUjk0L4CDfu/giphy.gif)](https://media.giphy.com/media/F7Wnsw3kUjk0L4CDfu/source.mp4)
[![demo sample tween](https://media.giphy.com/media/EY4RhVoqHTKVBJUNzW/giphy.gif)](https://media.giphy.com/media/EY4RhVoqHTKVBJUNzW/source.mp4)
[![directional blur filter](https://media.giphy.com/media/a4Rzda8uvFxCPvfI22/giphy.gif)](https://media.giphy.com/media/a4Rzda8uvFxCPvfI22/source.mp4)
[![hand drawing v1](https://media.giphy.com/media/uliHRVWVW5IlliliIi/giphy-downsized.gif)](https://media.giphy.com/media/uliHRVWVW5IlliliIi/source.mp4)
[![hand drawing v2](https://media.giphy.com/media/f6UJj36HqFYJuejz5M/giphy.gif)](https://media.giphy.com/media/f6UJj36HqFYJuejz5M/source.mp4)
[![drawing api playful v2](https://media.giphy.com/media/Ld3XIYErKsoyCQtzcg/giphy.gif)](https://media.giphy.com/media/Ld3XIYErKsoyCQtzcg/source.mp4)
[![elastic band](https://media.giphy.com/media/KiSrFNYQ7kED1HzSlJ/giphy.gif)](https://media.giphy.com/media/KiSrFNYQ7kED1HzSlJ/source.mp4)
[![Flare playback](https://media.giphy.com/media/t0ZcOUPdCtg8aPtL2B/giphy-downsized.gif)](https://media.giphy.com/media/t0ZcOUPdCtg8aPtL2B/source.mp4)
[![Flip child scenes](https://media.giphy.com/media/siMNzfRWTaKK9Pw0n2/giphy.gif)](https://media.giphy.com/media/siMNzfRWTaKK9Pw0n2/source.mp4)
[![Mix with Flutter widgets](https://media.giphy.com/media/YfzNLmfE1hutWI176e/giphy-downsized.gif)](https://media.giphy.com/media/YfzNLmfE1hutWI176e/source.mp4)
[![icon painter gradient](https://media.giphy.com/media/gC94IOdu6v1GoWJZWY/giphy.gif)](https://media.giphy.com/media/gC94IOdu6v1GoWJZWY/source.mp4)
[![inverted masks](https://media.giphy.com/media/1tsbaO28YXXxc1lvsd/giphy-downsized.gif)](https://media.giphy.com/media/1tsbaO28YXXxc1lvsd/source.mp4)
[![isometric demo](https://media.giphy.com/media/EInY3MKZ2xvmYNl3fm/giphy.gif)](https://media.giphy.com/media/EInY3MKZ2xvmYNl3fm/source.mp4)
[![light button](https://media.giphy.com/media/4Sspuw3R8Rdr2tsE4T/giphy.gif)](https://media.giphy.com/media/4Sspuw3R8Rdr2tsE4T/source.mp4)
[![marquesina de texto](https://media.giphy.com/media/Q2cIsU34CbzZHfNA2z/giphy.gif)](https://media.giphy.com/media/Q2cIsU34CbzZHfNA2z/source.mp4)
[![menu mask](https://media.giphy.com/media/xaEN62vmEQxTR1zFpy/giphy.gif)](https://media.giphy.com/media/xaEN62vmEQxTR1zFpy/source.mp4)
[![menu mouse](https://media.giphy.com/media/d9cQT0mOwgbRJ2fbyd/giphy.gif)](https://media.giphy.com/media/d9cQT0mOwgbRJ2fbyd/source.mp4)
[![nested transform touch](https://media.giphy.com/media/HLdqEQze3LUDlDCTBo/giphy.gif)](https://media.giphy.com/media/HLdqEQze3LUDlDCTBo/source.mp4)
[![particles with alpha](https://media.giphy.com/media/Z9D7bpWqjX8KJMTMMc/giphy-downsized.gif)](https://media.giphy.com/media/Z9D7bpWqjX8KJMTMMc/source.mp4)
[![particles blend](https://media.giphy.com/media/roD1B1diHxT9A61msb/giphy-downsized-large.gif)](https://media.giphy.com/media/roD1B1diHxT9A61msb/source.mp4)
[![progress panel](https://media.giphy.com/media/uygZcQPIe7Dp4RHHrB/giphy.gif)](https://media.giphy.com/media/uygZcQPIe7Dp4RHHrB/source.mp4)
[![rive playback](https://media.giphy.com/media/lVBkZ6o1qBqnek92Qj/giphy-downsized.gif)](https://media.giphy.com/media/lVBkZ6o1qBqnek92Qj/source.mp4)
[![rotation 3d](https://media.giphy.com/media/7T3hqnHc7cRrqEjE4a/giphy.gif)](https://media.giphy.com/media/7T3hqnHc7cRrqEjE4a/source.mp4)
[![spiral](https://media.giphy.com/media/z9FFwt6sPQSqrVuMyF/giphy-downsized.gif)](https://media.giphy.com/media/z9FFwt6sPQSqrVuMyF/source.mp4)
[![spritesheet explosion](https://media.giphy.com/media/Ldj7i8XiPZpYZ92WNN/giphy.gif)](https://media.giphy.com/media/Ldj7i8XiPZpYZ92WNN/source.mp4)
[![star effect](https://media.giphy.com/media/LFAhCww7vVItef78v9/giphy.gif)](https://media.giphy.com/media/LFAhCww7vVItef78v9/source.mp4)
[![text rainbow](https://media.giphy.com/media/wk8s7jJnwfdBQfbdvb/giphy.gif)](https://media.giphy.com/media/wk8s7jJnwfdBQfbdvb/source.mp4)
[![tween animation](https://media.giphy.com/media/XNO5QpJCyctdLZYMCS/giphy.gif)](https://media.giphy.com/media/XNO5QpJCyctdLZYMCS/source.mp4)
[![tween behaviour](https://media.giphy.com/media/DWbutR01h9LpschVDA/giphy.gif)](https://media.giphy.com/media/DWbutR01h9LpschVDA/source.mp4)
[![tween colo](https://media.giphy.com/media/1tjXlWG1ImPhI3eij4/giphy.gif)](https://media.giphy.com/media/1tjXlWG1ImPhI3eij4/source.mp4)


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
