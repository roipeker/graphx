import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class ElasticBandScene extends GSprite {
  static const referenceColor = Color(0xFFFF5252);

  GPoint dragPoint = GPoint();
  final myColors = [
    const Color(0xFF40C4FF),
    const Color(0xFF0288D1),
  ];
  bool isPressed = false;

  @override
  void addedToStage() {
    stage!.onMouseDown.add(_handleMouseDown);
    _handleUp(null);
  }

  void _handleMouseDown(e) {
    isPressed = true;
    stage!.onMouseMove.add(_handleMouseMove);
    stage!.onMouseUp.addOnce(_handleUp);
  }

  void _handleMouseMove(e) {
    tweenPoint(mouseX, mouseY, .18, GEase.easeOutQuad);
  }

  void _handleUp(e) {
    stage!.onMouseMove.remove(_handleMouseMove);
    isPressed = false;
    tweenPoint(
      stage!.stageWidth / 2,
      stage!.stageHeight / 2,
      1,
      GEase.elasticOut,
    );
  }

  GTween tweenPoint(double px, double py, double duration, EaseFunction ease) {
    /// another way to use Tweens.
    return GTween.to(
      GTweenablePoint(dragPoint),
      duration,
      {'x': px, 'y': py},
      GVars(
        onUpdate: drawLine,
        // overwrite: 1,
        ease: ease,
      ),
    );
  }

  void drawLine() {
    var sw = stage!.stageWidth;
    var sh = stage!.stageHeight;
    var cx = sw / 2;

    graphics
        .clear()
        .beginFill(Colors.blue)
        .beginGradientFill(GradientType.linear, myColors,
            begin: Alignment.topLeft, end: Alignment.bottomRight)
        .moveTo(cx, 0)
        .curveTo(dragPoint.x, dragPoint.y, cx, sh)
        .lineTo(sw, sh)
        .lineTo(sw, 0)
        .closePath()
        .endFill();

    /// draw reference line with dot.
    graphics
        .lineStyle(2, referenceColor.withOpacity(.3))
        .moveTo(cx, 0)
        .lineTo(dragPoint.x, dragPoint.y)
        .lineTo(cx, sh)
        .endFill();
    graphics
        .beginFill(referenceColor)
        .drawCircle(dragPoint.x, dragPoint.y, 6)
        .endFill();
  }
}
