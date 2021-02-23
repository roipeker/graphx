/// roipeker 2021

/// sample video:
/// https://media.giphy.com/media/xC8rB3jR9nXDJDMwQM/source.mp4

/// add graphx to your pubspec.
/// Add in ur code:
/// SceneBuilderWidget(builder: () => SceneController(front: SceneDialer()),),
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

const pinkColor = Color(0xffDD3D5C);

class DialerScene extends GSprite {
  Dialer dialer;

  @override
  void addedToStage() {
    dialer = Dialer(this);
    dialer.y = dialer.radius - kToolbarHeight;
    dialer.x = 240 + dialer.radius;
  }
}

class Dialer extends GSprite {
  double radius = 700 / 2;
  bool isPressed = false;
  GPoint pressed = GPoint();
  GShape bg;
  double prevRot = 0.0;
  double pressRot = 0.0;

  Dialer([GSprite doc]) {
    _draw();
    doc?.addChild(this);

    /// this activates the touch "detection" vs the Path of the shape, instead
    /// of the bounding box. More cpu expensive, but accurate.
    bg.mouseUseShape = true;
    bg.onMouseDown.add((event) {
      isPressed = true;
      pressed.setTo(mouseX, mouseY);
      prevRot = bg.rotation;
      pressRot = Math.atan2(mouseY, mouseX); //bg.rotation;
      stage.onMouseUp.add(
        (event) => isPressed = false,
      );
    });
  }

  @override
  void update(double delta) {
    super.update(delta);
    if (isPressed) {
      var angle = Math.atan2(mouseY, mouseX);
      bg.rotation = prevRot + (angle - pressRot);
    }
  }

  void _draw() {
    bg = GShape();
    addChild(bg);
    final g = bg.graphics;
    g
        .beginFill(kColorBlack.withOpacity(.2))
        .lineStyle(4, pinkColor)
        .drawCircle(0, 0, radius)
        .endFill();

    final smallRadius = radius * .96;
    // g.lineStyle(0, 0xffffff, .2);
    // g.drawCircle(0, 0, smallRadius).endFill();

    g.lineStyle(1, const Color(0xff574549).withOpacity(.8));
    final shortLine = 24.0;
    final longLine = 36.0;
    for (var i = 0.0; i < 360; ++i) {
      var angle = deg2rad(i);
      var lineSize = i % 5 == 0 ? longLine : shortLine;
      var innerRadius = smallRadius - lineSize;
      var cos1 = Math.cos(angle), sin1 = Math.sin(angle);
      g.moveTo(cos1 * smallRadius, sin1 * smallRadius);
      g.lineTo(cos1 * innerRadius, sin1 * innerRadius);

      /// debug circle.
      if (i == 180) {
        g.drawCircle(cos1 * innerRadius, sin1 * innerRadius, 20);
      }
    }
  }
}
