import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import '../../utils/demo_scene_widget.dart';

class FunMain extends StatelessWidget {
  const FunMain({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoSingleSceneWidget(
      root: FunScene(),
      config: SceneConfig.static,
    );
  }
}

class FunScene extends GSprite {
  @override
  void addedToStage() {
    // Rectangle
    final GShape rectangle = () {
      final shape = GShape();
      shape.graphics.lineStyle(2, const Color.fromARGB(255, 73, 244, 54));
      shape.graphics.drawRect(40, 40, 40, 40);
      shape.graphics.endFill();
      return shape;
    }();

    // Circle
    final GShape circle = () {
      final shape = GShape();
      shape.graphics.beginFill(const Color.fromARGB(255, 116, 104, 246)).drawCircle(80, 40, 20).endFill();
      return shape;
    }();

    // Face 1
    final GShape face = () {
      final shape = GShape();

      /// Head
      shape.graphics.beginFill(const Color.fromARGB(255, 255, 234, 77)).drawCircle(0, 0, 60).endFill();

      /// Eyes
      shape.graphics.beginFill(Colors.black).drawEllipse(-20, -10, 4, 8).drawEllipse(20, -10, 4, 8).endFill();

      /// mouth
      shape.graphics.lineStyle(2).arc(0, 5, 30, deg2rad(45), deg2rad(90)).endFill();

      shape.x = 200;
      shape.y = 100;
      return shape;
    }();

    // Face 2
    final GShape face2 = () {
      final shape = GShape();

      /// Head
      shape.graphics.beginFill(const Color.fromARGB(255, 228, 0, 0)).drawCircle(0, 0, 60).endFill();

      /// Eyes
      shape.graphics.beginFill(Colors.black).drawEllipse(-20, -10, 4, 8).drawEllipse(20, -10, 4, 8).endFill();

      /// mouth
      shape.graphics.lineStyle(2).arc(0, 10, 20, deg2rad(45), deg2rad(90)).endFill();

      shape.x = 250;
      shape.y = 150;

      return shape;
    }();

    // Triangle
    final GShape triangle = () {
      final shape = GShape();
      shape.graphics.beginGradientFill(
        GradientType.linear,
        [
          Colors.blue,
          const Color.fromARGB(255, 67, 244, 54),
        ],
        ratios: [
          0,
          1,
        ],
      );
      shape.graphics.drawPolygonFaces(0, 0, 140, 3).endFill();
      shape.rotation = -Math.PI / 2;
      shape.x = 300;
      shape.y = 500;
      return shape;
    }();

    // Painter's algorithm
    addChild(rectangle);
    addChild(circle);
    addChild(face2);
    addChild(face);
    addChild(triangle);
  }
}
