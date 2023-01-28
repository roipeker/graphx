import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class DnaScene extends GSprite {
  double spiralRadius = 0.0, centerX = 0.0, centerY = 0.0, centerZ = 0.0;
  double fl = 120;

  late List<Dot> dots;
  late Bar bar;
  late GSprite container;
  double sizeCounter = 0;

  @override
  void addedToStage() async {
    container = GSprite();
    addChild(container);
    // scale = 2;
    dots = List.generate(200, (index) {
      var dot = Dot();
      container.addChild(dot);
      dot.px = 200 - index * 2.0;
      dot.angle = index * 10.0;
      return dot;
    });
    bar = Bar();
    container.addChild(bar);
    bar.x = 30;
    container.y = stage!.stageHeight / 2;
  }

  @override
  void update(double delta) {
    super.update(delta);
    sizeCounter += delta;

    centerX = stage!.stageWidth / 2;
    centerY = 0; //stage.stageHeight / 2;
    centerZ = 160.0;
    bar.pz = centerZ;
    spiralRadius = 50;
    var barPercent = Math.sin(sizeCounter) / 2 + .5;
    bar.scaleX = .2 + barPercent;
    bar.x = 30 - Math.cos(sizeCounter) * (140 / 4);
    for (var dot in dots) {
      var dotAngle = deg2rad(dot.angle);
      dot.pz = Math.sin(dotAngle) * spiralRadius + centerZ;
      var fov = fl / (fl + dot.pz);

      /// calculate `py` position only, `px` is predefined in the
      /// initialization.
      dot.py = Math.cos(dotAngle) * spiralRadius;
      dot.x = dot.px * fov + centerX;
      dot.y = dot.py * fov + centerY;
      dot.scale = fov;
      dot.alpha = fov;
      dot.updateAngle();
    }

    container.sortChildren((a, b) {
      if (a is Object3d && b is Object3d) {
        return a.pz > b.pz ? -1 : 1;
      }
      return 0;
    });
  }
}

abstract class Object3d extends GSprite {
  double px = 0, pz = 0, py = 0, angle = 0;
}

class Bar extends Object3d {
  Bar() {
    graphics
        .lineStyle(6.0, Colors.orange)
        .moveTo(0, 0)
        .lineTo(140, 0)
        .endFill();
    // graphics.beginFill(Colors.blue.value).drawCircle(0, 0, 10).endFill();
  }
}

/// we just make a class to store the basic properties
/// for the calculations.
class Dot extends Object3d {
  // double px, angle, speed = -1;
  double speed = -1;

  Dot() {
    graphics.beginFill(Colors.blue).drawCircle(0, 0, 10).endFill();
  }

  void updateAngle() {
    angle += speed;
    if (angle >= 360) {
      angle -= 360;
    }
  }
}
