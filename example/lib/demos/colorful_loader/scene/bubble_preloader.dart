import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class BubblePreloader extends GSprite {
  static const gradientColors = <Color>[
    Color(0xFF9874D3),
    Color(0xFF6E7CCC),
    Color(0xFF56BFCA),
    Color(0xFF9874D3),
    Color(0xFF6E7CCC),
    Color(0xFF56BFCA),
  ];

  double w, h;
  GShape? bg, percentMask, bgGradient;
  late GSprite percentContainer, bubblesContainer;
  double borderRadius = 0.0, percent = 0.25, gradientShift = 0.0;
  Color bgColor = const Color(0xffDEE0E3);
  int numBubbles = 50;

  /// this should come from the flutter part, using ValueNotifier,
  /// or Graphx's MPS.
  final _twnPercent = 0.0.twn;

  BubblePreloader({this.w = 200, this.h = 80}) {
    borderRadius = h / 2;
    onAddedToStage.addOnce(_initUi);
  }

  void _initUi() {
    bg = GShape();

    percentContainer = GSprite();
    bubblesContainer = GSprite();

    bgGradient = GShape();
    percentMask = GShape();

    percentContainer.addChild(bgGradient!);
    percentContainer.addChild(bubblesContainer);
    addChild(bg!);
    addChild(percentContainer);
    addChild(percentMask!);
    percentContainer.mask = percentMask;

    _drawBack();
    _buildBubbles();

    /// uncomment for yoyo tween demo
    _tweenPercent();
  }

  void _tweenPercent() {
    _twnPercent.value = percent;

    /// toggle the percent between 1-0-1-0...
    var target = percent < 1 ? 1 : 0;
    _twnPercent.tween(
      target,
      duration: 2,
      onUpdate: () {
        percent = _twnPercent.value;
        _drawMask();
      },
      onComplete: _tweenPercent,
    );
  }

  void _buildBubbles() {
    _drawGradient();
    List.generate(numBubbles, (index) {
      var bubble = GShape();
      bubble.graphics
          .beginFill(kColorWhite.withOpacity(.4))
          .drawCircle(0, 0, 4)
          .endFill();
      bubble.x = Math.randomRange(0, w);
      bubble.y = Math.randomRange(-10, h + 10);
      bubble.scale = Math.randomRange(0.2, 1);
      if (Math.randomBool()) {
        var blur = Math.randomRange(1, 2);
        bubble.filters = [GBlurFilter(blur, blur)];
      }
      bubblesContainer.addChild(bubble);
    });
  }

  @override
  void update(double delta) {
    super.update(delta);
    gradientShift += .04;
    _drawGradient();
    _moveBubbles();
    _drawMask();
  }

  void _drawMask() {
    percentMask!.graphics
        .clear()
        .beginFill(bgColor)
        .drawRoundRect(0, 0, w * percent, h, borderRadius)
        .endFill();
  }

  void _moveBubbles() {
    for (var i = 0; i < numBubbles; ++i) {
      var bubble = bubblesContainer.getChildAt(i) as GShape;
      bubble.y -= 0.3 * bubble.scale;
      if (bubble.y < -10) {
        bubble.y = h + 10;
      }
    }
  }

  void _drawBack() {
    bg!.graphics
        .beginFill(bgColor)
        .drawRoundRect(0, 0, w, h, borderRadius)
        .endFill();
    _drawGradient();
  }

  void _drawGradient() {
    gradientShift %= 3;
    var a1 = -1.0 - gradientShift;
    var a2 = 4.0 - gradientShift;
    bgGradient!.graphics
        .clear()
        .beginGradientFill(
          GradientType.linear,
          gradientColors,
          begin: Alignment(a1, 0),
          end: Alignment(a2, 0),
        )
        .drawRoundRect(0, 0, w, h, borderRadius)
        .endFill();
  }
}
