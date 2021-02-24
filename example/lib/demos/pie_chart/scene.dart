import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class PieChartScene extends GSprite {
  @override
  void addedToStage() {
    var container = GSprite();
    var lineContainer = GSprite();
    addChild(container);
    addChild(lineContainer);
    container.centerInStage();
    lineContainer.centerInStage();
    lineContainer.mouseChildren = false;
    lineContainer.mouseEnabled = false;

    var sw2 = stage.stageWidth / 2;
    var numPieces = 5;
    var data = List.generate(numPieces, (index) => Math.randomRange(10, 50));
    var total = data.reduce((value, element) => value + element);
    final radius = sw2;
    final textSeparation = radius * .6;

    var totalRad = deg2rad(360);
    var currentAngle = 0.0;
    GSprite currentPiece;
    for (var i = 0; i < numPieces; ++i) {
      var color = Colors.primaries[(i) % Colors.primaries.length].value;
      var color1 = Color(color);
      var color2 = Color.lerp(color1, Colors.black, .8);
      var percent = data[i] / total;
      var myAngle = percent * totalRad;
      var pieceLine = GSprite();

      var piece = GSprite();
      piece.graphics
          .beginGradientFill(
            GradientType.radial,
            [
              color2.withOpacity(.8),
              color1.withOpacity(.95),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            radius: 2,
            // 2,
          )
          .moveTo(0, 0)
          .arc(0, 0, radius, 0, myAngle)
          .lineTo(0, 0)
          .endFill();
      piece.rotation = currentAngle;
      container.addChild(piece);
      piece.userData = pieceLine;
      piece.mouseChildren = false;
      piece.onMouseOver.add((e) {
        GDisplayObject line;
        if (currentPiece != null) {
          line = currentPiece.userData as GDisplayObject;
          GTween.killTweensOf(currentPiece);
          GTween.killTweensOf(line);
          currentPiece.tween(duration: .35, scale: 1, ease: GEase.easeInBack);
          line.tween(duration: .35, scale: 1, ease: GEase.easeInBack);
        }
//        var p = e.target;
        currentPiece = piece;
        line = currentPiece.userData as GDisplayObject;
//        e.target.scale = 1.4;
        GTween.killTweensOf(line);
        GTween.killTweensOf(piece);
        piece.tween(duration: .35, scale: .9, ease: GEase.easeOutExpo);
        line.tween(duration: .35, scale: .9, ease: GEase.easeOutExpo);
      });

      var percentText = (percent * 100.0).toStringAsPrecision(2);
      var valueText = GText(
        text: percentText,
        textStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          shadows: [Shadow(color: Colors.black54, blurRadius: 4.0)],
        ),
      );
      valueText.validate();
      valueText.alignPivot();
//      valueText.pivotX -= 10;

      var halfAng = myAngle / 2;

      var px = Math.cos(halfAng) * textSeparation;
      var py = Math.sin(halfAng) * textSeparation;
      valueText.x = px;
      valueText.y = py;

      var rot = Math.atan2(py, px);
      valueText.rotation = rot + Math.PI / 2;
      piece.addChild(valueText);

      pieceLine.graphics
          .lineStyle(0, Colors.white.withOpacity(.25))
          .moveTo(0, 0)
          .arc(0, 0, radius, 0, myAngle)
          .lineTo(0, 0)
          .closePath()
          .endFill();
      pieceLine.rotation = currentAngle;
      lineContainer.addChild(pieceLine);

      currentAngle += myAngle;
    }
  }
}

extension MyObject on GDisplayObject {
  void centerInStage() {
    if (!inStage) return;
    setPosition(stage.stageWidth / 2, stage.stageHeight / 2);
  }
}
