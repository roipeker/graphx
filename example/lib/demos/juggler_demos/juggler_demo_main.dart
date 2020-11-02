import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class JugglerDemoMain extends SceneRoot {
  JugglerDemoMain() {
    config(
      autoUpdateAndRender: true,
      sceneIsComplex: false,
      useTicker: true,
    );
  }

  @override
  void addedToStage() {
    print('added to stage@!');
    ball = DemoBall();
    addChild(ball);
  }

  Sprite ball;

//  @override
//  void init() {}

  @override
  void ready() {}

//  @override
//  void ready() {
  /// When resuming the ticker, we can manage when the Scene repaints with
  /// settings scene.needsRepaint=true / false
//    scene.needsRepaint = true;
//    scene.core.ticker.resume();
//    scene.core.ticker.onFrame.add((double time) {
//      scene.requestRender();
//    });
//    scene.needsRepaint = true;
//    super.ready();
//    scene.core.resumeTicker();
//    scene.needsRepaint = true;
//    stage.onEnterFrame.add(() {
//      print("OKA!");
//    });
//  }

  var stopwatch = Stopwatch();

  void test2() {}

//  void test() {
//    print('execute in 5 seconds.');
////    stopwatch.start();
////    print("stopwatch time:: ${stopwatch.elapsedMilliseconds}");
////    stage.juggler.delayedCall(
////      () {
////        print('Elapsed time: ${stage.juggler.elapsedTime}');
////        print('llamado dps de 2sec! ${stopwatch.elapsedMilliseconds}');
////        stopwatch.stop();
////      },
////      2,
////    );
//
//    var ball = Shape();
//    addChild(ball);
//    ball.graphics.beginFill(Colors.blue.value).drawCircle(0, 0, 30).endFill();
//    ball.setPosition(100, 100);
//    GxTween myTween;
//
//    ball.tween(
//      1,
//      delay: 2,
//      x: 400,
//      y: 80,
//      scale: 2,
//      reverse: true,
//      repeatDelay: 1,
//      easing: Curves.bounceOut.transform,
//      onComplete: (a) {
//        print("finished tween! // $a");
//        ball.removeFromParent();
//      },
//      onRepeat: (a) {
//        var twn = a.target;
//        twn.duration = twn.isReversed ? 1 : 2;
//        print("on tween repeat ${a.target.repeatCount}");
//        twn.transitionFun = twn.isReversed
//            ? Curves.elasticIn.transform
//            : Curves.elasticOut.transform;
//      },
//    );
//
//    return;
//    final ju = stage.juggler;
////    var twn = ju.getTweenById(id);
//
//    var o = {
//      'x': 10.0,
//      'y': 10.0,
//      'scale': 1.0,
//      'rotation': 0.0,
//    };
//
//    var obj = Shape();
////    obj.graphics.beginFill(0x0).drawCircle(0, 0, 20).endFill();
//    ball.graphics
//        .beginGradientFill(
//            GradientType.radial,
//            [
////              Color.lerp(Colors.red.shade400, Colors.black, .3).value,
//              Colors.red.shade800.value,
//              Colors.red.value,
//            ],
//            null,
////            [1, 1, 1],
//            null,
////            [0, .3, 1],
//            Alignment(.68, -.65),
//            null,
////            Alignment(-1, 1),
////            Alignment.topCenter,
////            Alignment.bottomRight,
//            null,
//            null,
//            1.0)
//        .drawCircle(0, 0, 20)
//        .endFill();
//    ball.x = 100;
//    ball.y = 100;
//    addChild(ball);
//
//    void updateObj() {
//      ball.x = o['x'];
//      ball.y = o['y'];
//      ball.scale = o['scale'];
//      ball.rotation = o['rotation'];
////      print(twn.target['a']);
//    }
//
//    var easings = [
//      Curves.easeInOutExpo.transform,
//      Curves.easeInQuad.transform,
//      Curves.decelerate.transform,
//      ...Transitions.values,
//    ];
//
//    void moveNext() {
//      double tx = GameUtils.rndRange(50, stage.stageWidth - 50);
//      double ty = GameUtils.rndRange(50, stage.stageHeight - 50);
//      double tscale = 1.0;
//      double trotation = 0.0;
//      if (GameUtils.rndBool()) {
//        trotation = GameUtils.rndRange(0, deg2rad(360));
//      }
//      if (GameUtils.rndBool()) {
//        tscale = GameUtils.rndRange(.5, 3);
//      }
//      double delay = GameUtils.rndRange(0, .6);
//      double duration = GameUtils.rndRange(0.4, 1.4);
//      Function ease = GameUtils.rndFromList(easings);
//      print('easing: $ease');
//      ju.tween(
//          o,
//          2.0,
//          {
//            'x': tx,
//            'y': ty,
//            'scale': tscale,
//            'rotation': trotation,
//          },
//          ease: ease,
//          delay: delay,
//          onUpdate: updateObj,
//          onComplete: moveNext);
//    }
//
//    moveNext();
}

class Ball extends Sprite {
  @override
  void addedToStage() {
    var ball = Shape();
    ball.graphics.beginFill(Colors.blue.value).drawCircle(0, 0, 30).endFill();
    ball.setPosition(100, 100);
    addChild(ball);
  }
}

class DemoBall extends Sprite {
  Ball ball;

  @override
  void addedToStage() {
    ball = addChild(Ball());
    ball.tween(3,
        delay: 1,
        x: 400,
        y: 80,
        scale: 2,
        ease: GxEase.easeOutCirc,
        onComplete: _onTweenComplete);
  }

  _onTweenComplete(e) {
    print(e);
  }
}

extension ExtDisplayObjectTween on DisplayObject {
  static var _tweenMap = <DisplayObject, List<Map<String, double>>>{};

  getProperty(String key) {}
  setProperty(String key, double value) {}

  GxTween tween(
    double duration, {
    double delay,
    double x,
    double y,
    double scale,
    double scaleX,
    double scaleY,
    double rotation,
    double pivotX,
    double pivotY,
    EaseFunction ease,
    GxTweenCallback onStart,
    GxTweenCallback onUpdate,
    GxTweenCallback onComplete,
    GxTweenCallback onRepeat,
    Function onStartArgs,
    Function onUpdateArgs,
    Function onCompleteArgs,
    Function onRepeatArgs,
    int repeat = 1,
    bool reverse = false,
    double repeatDelay = 0,
  }) {
    var obj = <String, double>{};
    var to = <String, double>{};
    var setters = <String, Function(double)>{};

    void _addProp(
        String key, double end, double start, Function(double) setter) {
      to[key] = end;
      obj[key] = start;
      setters[key] = setter;
    }

    _tweenMap[this] ??= [];
    _tweenMap[this].add(obj);
    if (x != null)
      _addProp(
        'x',
        x,
        this.x,
        (double val) => this.x = val,
      );
    if (y != null)
      _addProp(
        'y',
        y,
        this.y,
        (double val) => this.y = val,
      );
    if (scaleX != null)
      _addProp(
        'scaleX',
        scaleX,
        this.scaleX,
        (double val) => this.scaleY = val,
      );
    if (scaleY != null)
      _addProp(
        'scaleY',
        scaleY,
        this.scaleY,
        (double val) => this.scaleX = val,
      );
    if (scale != null)
      _addProp(
        'scale',
        scale,
        this.scale,
        (double val) => this.scale = val,
      );
    if (rotation != null)
      _addProp(
        'rotation',
        rotation,
        this.rotation,
        (double val) => this.rotation = val,
      );
    if (pivotX != null)
      _addProp(
        'pivotX',
        pivotX,
        this.pivotX,
        (double val) => this.pivotX = val,
      );
    if (pivotY != null)
      _addProp(
        'pivotY',
        pivotY,
        this.pivotY,
        (double val) => this.pivotY = val,
      );
    var tween = GxTween.fromPool(obj, duration);
    tween.delay = delay;
    for (var prop in to.keys) {
      tween.animate(prop, to[prop]);
    }
    tween.transitionFun = ease ?? Curves.decelerate.transform;
    tween.onUpdate = (e) {
      for (final prop in obj.keys) {
        setters[prop](obj[prop]);
      }
      onUpdate?.call(e);
    };

    tween.onComplete = (e) {
      for (final prop in obj.keys) {
        setters[prop](obj[prop]);
      }
      onComplete?.call(e);
    };
    tween.onStartArgs = onStartArgs;
    tween.onUpdateArgs = onUpdateArgs;
    tween.onCompleteArgs = onCompleteArgs;
    tween.onRepeatArgs = onRepeatArgs;
    tween.onRepeat = onRepeat;
    tween.reverse = reverse;
    tween.repeatCount = repeat;
    tween.repeatDelay = repeatDelay;
    tween.onRemovedFromJuggler.add((e) {
      GxTween.toPool(e.target as GxTween);
    });
    if (inStage) {
      stage.juggler.add(tween);
    }
    return tween;
  }
}
