/// roipeker 2020
///
/// video demo: https://media.giphy.com/media/rWF1Sc4CGLf3zfYlXn/source.mp4
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class GaugeMeterScene extends GSprite {
  late GSprite container;
  late GShape nailMeter;
  late GText labelValue;
  double swipeAngle = Math.PI * .8;
  late double offsetAngle;
  Color nailColor = Colors.redAccent;
  String letterValue = 'A';
  int gaugeSteps = 7;
  double maxValue = 90;
  late double stepValueDeg;

  double get sw => stage!.stageWidth;

  double get sh => stage!.stageHeight;

  @override
  void addedToStage() {
    // stage.showBoundsRect = true;
    _init();
  }

  void _init() {
    container = GSprite();
    addChild(container);

    var curve = GShape();
    container.addChild(curve);
    var bigRadius = 214 / 2;
    final baseColor = Color.lerp(nailColor, Colors.black, .6)!;
    offsetAngle = -(Math.PI / 2) - swipeAngle / 2;
    var g = curve.graphics;

    /// draw the lines.
    stepValueDeg = maxValue / (gaugeSteps - 1);
    var angleStep = swipeAngle / (gaugeSteps - 1);
    var bigLineRadius = bigRadius + 15;

    var circleLineThickness = 5.0, stepLineThickness = 1.0;

    g.lineStyle(stepLineThickness, baseColor);
    var smallGaugeSteps = 4;
    var totalGaugeSteps = (smallGaugeSteps * (gaugeSteps - 1)) + gaugeSteps;
    angleStep = swipeAngle / (totalGaugeSteps - 1);
    var smallLineRadius = bigRadius + 6;
    var textRadius = bigLineRadius + 14;
    var textValueCounter = 0.0;
    var offsetBoundLines = stepLineThickness * .005;

    for (var i = 0; i < totalGaugeSteps; ++i) {
      var isBig = i % (smallGaugeSteps + 1) == 0;
      var lineRadius = isBig ? bigLineRadius : smallLineRadius;
      var currentAngle = offsetAngle + i * angleStep;
      if (i == 0) {
        currentAngle += offsetBoundLines;
      } else if (i == totalGaugeSteps - 1) {
        currentAngle -= offsetBoundLines;
      }
      var cos1 = Math.cos(currentAngle);
      var sin1 = Math.sin(currentAngle);

      // g.moveTo(0, 0);
      if (isBig) {
        var label = GText(
          text: '${textValueCounter.round()}',
          textStyle: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: baseColor,
          ),
        );
        textValueCounter += stepValueDeg;
        container.addChild(label);
        label.alignPivot();
        label.x = cos1 * textRadius;
        label.y = sin1 * textRadius;
      }
      g.moveTo(cos1 * bigRadius, sin1 * bigRadius);
      g.lineTo(cos1 * lineRadius, sin1 * lineRadius);
    }
    g.endFill();

    bigRadius -= circleLineThickness / 2;
    g.lineStyle(circleLineThickness, baseColor, true, StrokeCap.butt);
    g.arc(0, 0, bigRadius, offsetAngle, swipeAngle);
    g.endFill();

    // big value text.
    var labelA = GText(
      text: letterValue,
      textStyle: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: baseColor,
        decoration: TextDecoration.underline,
      ),
    );
    container.addChild(labelA);
    labelA.alignPivot(Alignment.bottomCenter);
    labelA.y = -35;

    // value text.
    labelValue = GText(
      text: '0',
      // width: bigRadius * 2,
      textStyle: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w100,
        color: baseColor,
      ),
    );
    container.addChild(labelValue);
    labelValue.alignPivot();
    labelValue.onFontLoaded.addOnce(() {
      labelValue.alignPivot();
    });
    nailMeter = GShape();
    var nailH = bigRadius / 2;
    container.addChild(nailMeter);
    g = nailMeter.graphics;
    // g.beginFill(0xFA2B2B);
    g.beginFill(nailColor);
    g.drawPolygonFaces(0, 0, nailH, 3);
    g.endFill();
    nailMeter.height = 16;
    nailMeter.alignPivot(const Alignment(-1.6, 0));
    container.alignPivot();

    // adjust size
    // container.scale = .5;
    // container.$debugBounds = true;
    stage!.onResized.add(() {
      var graphBounds = container.bounds!;
      var r1 = sw / sh;
      var r2 = graphBounds.width / graphBounds.height;
      if (r1 < r2) {
        container.width = sw;
        container.scaleY = container.scaleX;
      } else {
        container.height = sh;
        container.scaleX = container.scaleY;
      }
      container.setPosition(sw / 2, sh / 2);
    });
  }

  @override
  void update(double delta) {
    super.update(delta);
    var t = getTimer() / 1000;
    var percent = .5 + Math.sin(t) / 2;
    nailMeter.rotation = offsetAngle + percent * swipeAngle;
    labelValue.text = (percent * maxValue).round().toString();
    labelValue.alignPivot();
  }
}
