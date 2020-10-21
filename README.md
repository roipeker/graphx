# GraphX™

GraphX™ rendering lib, 
 prototype code with a prototype lib

> *WARNING:* this is WIP code, based on a few days of experimentation.

> *NOTE:* GraphX™ uses the `$` prefix convention to all "internal/private" members (properties and methods). __DO NOT__ call them in your code... is meant to be consumed internally by the lib.
___

## Background

GraphX™ is here to help you build custom drawing in your Flutter apps. Providing an amazing versatility to power those screen pixels to a different level.

It's inspired by the good-old Flash API, which forged my way into programming back in the days, and also shaped many other rendering frameworks in several languages through the years.

I was thinking how much I missed to "play" with code, to make things more organic, artistic, alive... I totally love Flutter,  but I always feel that it requires too much boilerplate to make things move around (compared to what I used to code).

Even if GraphX™ is not a tween or physics engine (in fact it doesn't even have one, yet), it runs on top of CustomPainter, it uses what Flutter SDK exposes from the SKIA engine, through the Canvas, but gives you a "framework" to isolate yourself from the Widget world.

It can be used to simple draw a line, a circle, a custom button, some splash effect on your UI, or even a full blown game in a portion of you screen. Mix and match with Flutter as you please, as GraphX™ uses CustomPainter, is part of your widget tree.


So, let your imagination fly.    
   
## concept.

This is just a very early WIP to put something online... still lacks support for loading images, rendering Text, etc. 

GraphX™ drives a CustomPainter inside, the idea is to simplify the usage of Flutter's `Canvas`, plus adding the DisplayList concept, so you can manage and create more complex "scenes".

GraphX™ has it's own rendering cycle (no AnimationController), and input capture, even if it runs on the Widget tree, you can enable the flags to capture mouse/touch input (through the `stage.pointer`), or keystrokes events (if u wanna do some simple game).
   
### sample code.

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

Each "Scene Layer" has to extend `RootScene`, it represents the starting point of that particular scene hierarchy. Think of it as `MaterialApp` widget is to all other children Widgets in the tree.  

Here we get into **GraphX™** world, no more Widgets Trees or immutable properties.

You can override `init()` to setup things needed for this current Scene Painter object, like if it needs keyboard/mouse/touch access, or if it requires a `Ticker` and redraw the CustomPainter, cause it will animate.

Override `ready()` as your entry point, here the engine is set up, and the glorified `Stage` is available to use.

```dart
class GameScene extends RootScene {
  @override
  init() {
    owner.needsRepaint = true;
    owner.core.config.painterWillChange = true;
    owner.core.config.usePointer = true;
    owner.core.config.useTicker = true;
  }

  @override
  void ready() {
    super.ready();
    owner.core.resumeTicker(); /// we can "start" and pause the Ticker on demand.
    ...
  }
```

For now, GraphX™ has a couple of classes for rendering the display list:
`Shape` and `Sprite` (`DisplayObject`, `DisplayObjectContainer` are _abstracts_),

They both have a `graphics` property which is of type `Graphics` and provides a simplistic API to paint on the Flutter's `Canvas`.

By the way, `RootScene` is a Sprite!, and it's your `root` node in the display tree, kinda where all starts to render, and where you need to add your own objects.

For instance, to create a simple purple circle:

```dart
@override
ready(){
    var circle = Shape();
    circle.graphics.lineStyle(2, Colors.purple.value) /// access hex value of Color
      ..drawCircle(0, 0, 20)
      ..endFill();
    addChild(circle); // add the child to the rootScene.
}
```

`RootScene` is a `Sprite` (which is a `DisplayObjectContainer`) and can have children inside, yet `Shape` is a `DisplayObject`, and can't have children. But it makes it a little bit more performant on each painter step.

We could also use our root scene to draw things:

```dart
@override
ready(){
  graphics.beginFill(0x0000ff, .6)
  ..drawRoundRect(100, 100, 40, 40, 4)
  ..endFill();
...
}
```


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

----


Resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
