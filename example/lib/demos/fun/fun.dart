import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import '../../utils/demo_scene_widget.dart';

class FunMain extends StatelessWidget {
  const FunMain({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoSingleSceneWidget(
      root: FunScene(),
      config: SceneConfig.autoRender,
    );
  }
}

class FunScene extends GSprite {
  late GSprite container;
  late GSprite overlay;
  late GText label;
  late GShape triangle;
  late GShape circle;
  late GShape topLeftRectangle;
  late GShape bottomRightRectangle;

  @override
  void addedToStage() {
    stage?.$debugBounds = true;
    _init();
  }

  @override
  void update(double delta) {
    trace('update');
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
      final grx = shape.graphics;

      grx.lineStyle(2, const Color.fromARGB(255, 194, 220, 245));
      grx.drawRect(-160, -160, 320, 320);
      grx.endFill();
      return shape;
    }();

    topLeftRectangle = () {
      final shape = GShape();
      final grx = shape.graphics;

      grx.lineStyle(2, const Color.fromARGB(255, 156, 152, 255));
      grx.drawRect(0, 0, 32, 32);
      grx.endFill();
      return shape;
    }();

    bottomRightRectangle = () {
      final shape = GShape();
      final grx = shape.graphics;

      grx.lineStyle(2, const Color.fromARGB(255, 142, 146, 248));
      grx.drawRect(0, 0, 32, 32);
      grx.endFill();
      return shape;
    }();

    // Circle
    circle = () {
      final shape = GShape();
      final grx = shape.graphics;

      grx.beginFill(const Color.fromARGB(255, 246, 104, 104)).drawCircle(0, 0, 20).endFill();
      return shape;
    }();

    // Face
    final GShape face = () {
      final shape = GShape();
      final grx = shape.graphics;

      // Head
      grx
          .lineStyle(4, const Color.fromARGB(255, 148, 159, 23))
          .beginFill(const Color.fromARGB(255, 255, 234, 77))
          .drawCircle(0, 0, 60)
          .endFill();

      // Eyes
      grx.beginFill(Colors.black).drawEllipse(-20, -20, 4, 8).drawEllipse(20, -20, 4, 8).endFill();

      /// mouth
      grx.lineStyle(2).moveTo(-16, 32).lineTo(16, 32);

      return shape;
    }();

    // Happy Face
    final GShape happyFace = () {
      final shape = GShape();
      final grx = shape.graphics;

      // Head
      grx
          .lineStyle(4, const Color.fromARGB(255, 186, 99, 53))
          .beginFill(const Color.fromARGB(255, 238, 137, 74))
          .drawCircle(0, 0, 40)
          .endFill();

      // Eyes
      grx.beginFill(Colors.black).drawEllipse(-16, -8, 4, 4).drawEllipse(16, -8, 4, 4).endFill();

      // mouth
      grx.lineStyle(2).arc(0, 5, 16, deg2rad(45), deg2rad(90)).endFill();

      return shape;
    }();

    // Sad Face
    final GShape sadFace = () {
      final shape = GShape();
      final grx = shape.graphics;

      // Head
      grx
          .lineStyle(4, const Color.fromARGB(255, 35, 148, 35))
          .beginFill(const Color.fromARGB(255, 143, 181, 97))
          .drawCircle(0, 0, 40)
          .endFill();

      // Eyes
      grx.beginFill(Colors.black).drawEllipse(-16, -8, 3, 10).drawEllipse(16, -8, 3, 10).endFill();

      // mouth
      grx.lineStyle(2).arc(0, 36, 16, deg2rad(45 + 180), deg2rad(90)).endFill();

      return shape;
    }();

    // Triangle
    triangle = () {
      final shape = GShape();
      final grx = shape.graphics;

      grx.beginGradientFill(
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

      shape.$debugBounds = true;

      return shape;
    }();

    container = GSprite();
    overlay = GSprite();

    // Add root containers
    addChild(container);
    addChild(overlay);

    overlay.addChild(topLeftRectangle);
    overlay.addChild(bottomRightRectangle);

    // Position and scale
    sadFace.x = 80;
    sadFace.scale = 0.75;

    happyFace.x = -100;
    happyFace.scale = 1.2;

    label.y = 100;

    // Add to container (Painter's algorithm, last child on top)
    container.addChild(triangle);
    container.addChild(sadFace);
    container.addChild(face);
    container.addChild(happyFace);
    container.addChild(circle);
    container.addChild(rectangle);
    container.addChild(label);

    // Fit container size and position to current stage
    stage!.onResized.add(() {
      // Handle Size changes

      var bounds = container.bounds!;
      var stageWidth = stage!.stageWidth;
      var stageHeight = stage!.stageHeight;

      // Container
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

      // if (topLeft != null) {
      //   topLeftRectangle.setPosition(-topLeft.left, -topLeft.top);
      // }

      topLeftRectangle.setPosition(16, 16);

      final bottomRight = topLeftRectangle.getBounds(stage!);
      if (bottomRight != null) {
        bottomRightRectangle.setPosition(
          stageWidth - 16 - bottomRight.width,
          stageHeight - 16 - bottomRight.height,
        );
      }
    });
  }

  void _update(double delta) {
    // Handle Animation

    var t = getTimer() / 1000;
    var percent = 0.5 + Math.sin(t) / 2;

    triangle.rotation = percent * Math.PI * .8;

    circle.scale = percent + 0.25;

    label.text = (percent * 100).round().toString();
    label.alignPivot();
  }
}
