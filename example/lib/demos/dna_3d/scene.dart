import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class DnaScene extends GSprite {
  double spiralRadius = 0.0, centerX = 0.0, centerY = 0.0, centerZ = 0.0;
  double fl = 150;

  late List<Dot> dots;

  @override
  void addedToStage() async {
    stage!.color = Colors.white;
    dots = List.generate(80, (index) {
      var dot = Dot();
      addChild(dot);
      dot.py = -200.0 + index * 5.0;
      dot.angle = index * 20.0;
      return dot;
    });
  }

  @override
  void update(double delta) {
    super.update(delta);
    centerX = stage!.stageWidth / 2;
    centerY = stage!.stageHeight / 2;
    centerZ = 100.0;
    spiralRadius = (mouseX - centerX) / 4;

    for (var dot in dots) {
      final dotAngle = deg2rad(dot.angle);
      final pz = Math.sin(dotAngle) * spiralRadius + centerZ;
      final fov = fl / (fl + pz);

      /// calculate `px` position only, `py` is predefined in the
      /// initialization.
      var px = Math.cos(dotAngle) * spiralRadius;
      dot.x = px * fov + centerX;
      dot.y = dot.py * fov + centerY;
      dot.alpha = dot.scale = fov;

      dot.updateAngle();
    }
  }
}

/// we just make a class to store the basic properties
/// for the calculations.
class Dot extends GShape {
  double py = 0.0, angle = 0.0, speed = 5;

  Dot() {
    graphics.beginFill(kColorBlack).drawCircle(0, 0, 10).endFill();
  }

  void updateAngle() {
    angle += speed;
    if (angle >= 360) {
      angle -= 360;
    }
  }
}
