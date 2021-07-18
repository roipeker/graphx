import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class FlowerScene extends GSprite {
  @override
  void addedToStage() {
    createFlower();
  }

  void createFlower() {
    var flower = GSprite();
    addChild(flower);
    flower.setPosition(stage!.stageWidth / 2, stage!.stageHeight / 2);

    var numLines = 8;

    flower.tween(
      duration: 5,
      scale: 2,
      delay: 0,
      rotation: deg2rad(180 * 6.0),
      ease: GEase.decelerate,
    );

    for (var i = 0; i < numLines; ++i) {
      var shape = GShape();
      flower.addChild(shape);
      shape.name = 's$i';

      var color1 = Colors.primaries[i % Colors.primaries.length];
      var color2 = Color.lerp(color1, Colors.black, .4)!;

      shape.graphics.beginGradientFill(
        GradientType.linear,
        [color1.withOpacity(.9), color2.withOpacity(.8)],
        ratios: [0, 1],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
      shape.graphics.drawRoundRect(0, 0, 40, 100, 20);
      shape.graphics.endFill();
      shape.alpha = .5;
      shape.alignPivot(Alignment.bottomCenter);

      var angle = (i / numLines) * 360;
      shape.tween(
        duration: 0.8,
        rotation: deg2rad(angle),
        delay: .5 + i * .08,
        ease: GEase.elasticOut,
      );
    }

    GTween.delayedCall(
      2,
      () {
        for (var i = 0; i < numLines; ++i) {
          var j = numLines - i;
          flower.children[i].tween(
            duration: .6,
            rotation: 0,
            delay: j * .08,
            // overwrite: 1,
            ease: GEase.easeInBack,
          );
        }
      },
    );
  }
}
