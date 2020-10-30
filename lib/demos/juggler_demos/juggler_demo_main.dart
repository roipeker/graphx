import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphx/gameutils.dart';
import 'package:graphx/graphx/animations/easings.dart';
import 'package:graphx/graphx/core/graphx.dart';
import 'package:graphx/graphx/render/graphics.dart';
import 'package:graphx/graphx/utils/math_utils.dart';

class JugglerDemoMain extends RootScene {
  @override
  void init() {
    owner.core.config.useTicker = true;
//    owner.core.config.useKeyboard = true;
//    owner.core.config.usePointer = true;
  }

  @override
  void ready() {
    super.ready();
    owner.core.resumeTicker();
    owner.needsRepaint = true;
    test();
  }

  var stopwatch = Stopwatch();

  void test() {
    print('execute in 5 seconds.');
//    stopwatch.start();
//    print("stopwatch time:: ${stopwatch.elapsedMilliseconds}");
//    stage.juggler.delayedCall(
//      () {
//        print('Elapsed time: ${stage.juggler.elapsedTime}');
//        print('llamado dps de 2sec! ${stopwatch.elapsedMilliseconds}');
//        stopwatch.stop();
//      },
//      2,
//    );

    final ju = stage.juggler;

//    var twn = ju.getTweenById(id);
    var o = {
      'x': 10.0,
      'y': 10.0,
      'scale': 1.0,
      'rotation': 0.0,
    };

    var obj = Shape();
//    obj.graphics.beginFill(0x0).drawCircle(0, 0, 20).endFill();
    obj.graphics
        .beginGradientFill(
            GradientType.radial,
            [
//              Color.lerp(Colors.red.shade400, Colors.black, .3).value,
              Colors.red.shade800.value,
              Colors.red.value,
            ],
            null,
//            [1, 1, 1],
            null,
//            [0, .3, 1],
            Alignment(.68, -.65),
            null,
//            Alignment(-1, 1),
//            Alignment.topCenter,
//            Alignment.bottomRight,
            null,
            null,
            1.0)
        .drawCircle(0, 0, 20)
        .endFill();
    obj.x = 100;
    obj.y = 100;
    addChild(obj);

    void updateObj() {
      obj.x = o['x'];
      obj.y = o['y'];
      obj.scale = o['scale'];
      obj.rotation = o['rotation'];
//      print(twn.target['a']);
    }

    var easings = [
      Curves.easeInOutExpo.transform,
      Curves.easeInQuad.transform,
      Curves.decelerate.transform,
      ...Transitions.values,
    ];

    void moveNext() {
      double tx = GameUtils.rndRange(50, stage.stageWidth - 50);
      double ty = GameUtils.rndRange(50, stage.stageHeight - 50);
      double tscale = 1.0;
      double trotation = 0.0;
      if (GameUtils.rndBool()) {
        trotation = GameUtils.rndRange(0, deg2rad(360));
      }
      if (GameUtils.rndBool()) {
        tscale = GameUtils.rndRange(.5, 3);
      }
      double delay = GameUtils.rndRange(0, .6);
      double duration = GameUtils.rndRange(0.4, 1.4);
      Function ease = GameUtils.rndFromList(easings);
      print('easing: $ease');
      ju.tween(
          o,
          2.0,
          {
            'x': tx,
            'y': ty,
            'scale': tscale,
            'rotation': trotation,
          },
          ease: ease,
          delay: delay,
          onUpdate: updateObj,
          onComplete: moveNext);
    }

    moveNext();

    //
//    var id = ju.tween(o, 2.0, {'x': 120.0, 'y': 300.0},
//        ease: Curves.bounceOut.transform,
//        delay: 3,
//        onUpdate: updateObj, onComplete: () {
//      ju.tween(o, 3.0, {'x': 80.0, 'y': 90.0},
//          ease: Transitions.easeOutElastic,
//          onUpdate: updateObj, onComplete: () {
//        print("FINISH TOTAL!");
//      });
//    });

//    print(twn);
  }
}
