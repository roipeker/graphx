import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class SimpleShapesScene extends Sprite {
  Shape triangle;

  @override
  void addedToStage() {
    /// For example:
    /// If you pass a [SceneConfig] with [useTicker] or [autoUpdate],
    /// this is how you can turn off the update/rendering process for this
    /// scene layer.
    // stage.scene.autoUpdateAndRender = false;

    final rect = Shape();
    rect.graphics.lineStyle(2, Colors.red.value, 1.0);
    rect.graphics.drawRect(40, 40, 40, 40);
    rect.graphics.endFill();
    addChild(rect);

    var circ = Shape();
    circ.graphics.beginFill(0x0).drawCircle(80, 40, 20).endFill();
    addChild(circ);

    /// multiple commands in 1 shape.
    var face = Shape();

    /// head
    face.graphics
        .beginFill(Colors.yellow.value, .5)
        .drawCircle(0, 0, 60)
        .endFill();

    /// eyes
    face.graphics
        .beginFill(0x0, 1)
        .drawEllipse(-20, -10, 4, 8)
        .drawEllipse(20, -10, 4, 8)
        .endFill();

    /// mouth
    face.graphics
        .lineStyle(2, 0x0, 1)
        .arc(0, 10, 20, deg2rad(45), deg2rad(90))

        /// sad face
//        .arc(0, 30, 20, deg2rad(0), deg2rad(-180))
        .endFill();
    face.x = 200;
    face.y = 100;
    addChild(face);

    triangle = Shape();
    addChild(triangle);
    triangle.graphics.beginGradientFill(
      GradientType.linear,
      [Colors.blue.value, Colors.red.value],
      alphas: [1, 1],
      ratios: [0, 1],
    );
    triangle.graphics.drawPolygonFaces(0, 0, 40, 3).endFill();
    triangle.rotation = -pi / 2;
    triangle.x = face.x + face.width / 2 + triangle.width / 2;
    triangle.y = face.y;
  }
}
