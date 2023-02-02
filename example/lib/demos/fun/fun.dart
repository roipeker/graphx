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
  late GSprite container;
  late GText label;

  @override
  void addedToStage() {
    _init();
  }

  @override
  void update(double delta) {
    super.update(delta);
    _update(delta);
  }

  void _init() {
    // Label
    label = () {
      final text = GText(
        text: 'GraphX',
        textStyle: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w500,
          color: Color.fromARGB(255, 149, 127, 223),
        ),
      );
      text.alignPivot();
      text.onFontLoaded.addOnce(() {
        text.alignPivot();
      });
      return text;
    }();

    // Rectangle
    final GShape rectangle = () {
      final shape = GShape();
      shape.graphics.lineStyle(2, const Color.fromARGB(255, 194, 220, 245));
      shape.graphics.drawRect(-160, -160, 320, 320);
      shape.graphics.endFill();
      return shape;
    }();

    // Circle
    final GShape circle = () {
      final shape = GShape();
      shape.graphics.beginFill(const Color.fromARGB(255, 246, 104, 104)).drawCircle(0, 0, 20).endFill();
      return shape;
    }();

    // Face 1
    final GShape face = () {
      final shape = GShape();

      // Head
      shape.graphics.beginFill(const Color.fromARGB(255, 255, 234, 77)).drawCircle(0, 0, 60).endFill();

      // Eyes
      shape.graphics.beginFill(Colors.black).drawEllipse(-20, -20, 4, 8).drawEllipse(20, -20, 4, 8).endFill();

      /// mouth
      shape.graphics.lineStyle(2).moveTo(-16, 32).lineTo(16, 32);

      return shape;
    }();

    // Happy Face
    final GShape happyFace = () {
      final shape = GShape();

      // Head
      shape.graphics.beginFill(const Color.fromARGB(255, 238, 137, 74)).drawCircle(0, 0, 40).endFill();

      // Eyes
      shape.graphics.beginFill(Colors.black).drawEllipse(-16, -8, 4, 8).drawEllipse(16, -8, 4, 8).endFill();

      // mouth
      shape.graphics.lineStyle(2).arc(0, 5, 16, deg2rad(45), deg2rad(90)).endFill();

      return shape;
    }();

    // Sad Face
    final GShape sadFace = () {
      final shape = GShape();

      // Head
      shape.graphics.beginFill(const Color.fromARGB(255, 143, 181, 97)).drawCircle(0, 0, 40).endFill();

      // Eyes
      shape.graphics.beginFill(Colors.black).drawEllipse(-16, -8, 4, 8).drawEllipse(16, -8, 4, 8).endFill();

      // mouth
      shape.graphics.lineStyle(2).arc(0, 32, 16, deg2rad(45 + 180), deg2rad(90)).endFill();

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
      return shape;
    }();

    container = GSprite();
    addChild(container);

    // Position and scale
    sadFace.x = 80;
    sadFace.scale = 0.75;

    happyFace.x = -100;
    happyFace.scale = 1.2;

    label.y = 100;

    // Painter's algorithm
    container.addChild(triangle);
    container.addChild(face);
    container.addChild(sadFace);
    container.addChild(happyFace);
    container.addChild(circle);
    container.addChild(rectangle);
    container.addChild(label);

    // Fit container size and position to current stage
    stage!.onResized.add(() {
      var bounds = container.bounds!;
      var stageWidth = stage!.stageWidth;
      var stageHeight = stage!.stageHeight;

      var stageRatio = stageWidth / stageHeight;
      var boundsRatio = bounds.width / bounds.height;
      if (stageRatio < boundsRatio) {
        container.width = stageWidth;
        container.scaleY = container.scaleX;
      } else {
        container.height = stageHeight;
        container.scaleX = container.scaleY;
      }
      container.setPosition(stageWidth / 2, stageHeight / 2);
    });
  }

  void _update(double delta) {
    var t = getTimer() / 100;
    var percent = 0.5 + Math.sin(t) / 2;
  }
}
