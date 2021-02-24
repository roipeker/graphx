import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'bezier_points.dart';

class CurvedGraphScene extends GSprite {
  List<double> graphPositions = [.2, .4, .9, .3, .6, .7, .9, .3];
  List<GPoint> bezierPoints;

  double get graphW => stage.stageWidth;
  double get graphH => stage.stageHeight;

  GSprite graph, dots;
  GShape lines, filled;
  List<GPoint> coords;

  GTweenableList myTweenList;
  List<double> lastPercents;

  GShape drawCircle(double px, double py) {
    var sh = GShape();
    dots.addChild(sh);
    sh.graphics.beginFill(Colors.red).drawCircle(0, 0, 2).endFill();
    sh.setPosition(px, py);
    return sh;
  }

  @override
  void addedToStage() {
    bezierPoints = [];
    // stage.color = Colors.black;
    stage.maskBounds=true;

    graph = GSprite();
    dots = GSprite();
    lines = GShape();
    filled = GShape();

    addChild(filled);
    addChild(lines);
    addChild(graph);
    addChild(dots);
    coords = [];
    var dotSep = graphW / (graphPositions.length - 1);
    graph.graphics.lineStyle(.1, Colors.lightBlueAccent.withOpacity(.8));
    graph.graphics.drawRect(0, 0, graphW, graphH);
    for (var i = 0; i < graphPositions.length; ++i) {
      var px = i * dotSep;
      var py = graphPositions[i] * graphH;
      graph.graphics.moveTo(px, 0).lineTo(px, graphH);
      coords.add(GPoint(px, py));
      drawCircle(px, py);
    }
    lastPercents = List.from(graphPositions);
    myTweenList = lastPercents.twn;
    randomNumbers();
    stage.onMouseClick.add((e) => randomNumbers());
  }

  void randomNumbers() {
    var newValues = lastPercents.map((e) => Math.random()).toList();
    for (var i = 0; i < dots.children.length; ++i) {
      var dot = dots.children[i];
      dot.tween(
        delay: i * .12,
        duration: .6,
        scale: 2.2,
        alpha: .5,
        ease: GEase.easeInExpo,
        colorize: Colors.white,
        overwrite: 1,
      );
      dot.tween(
        delay: 1 + i * .08,
        duration: .9,
        scale: 1,
        ease: GEase.easeOutBack,
        alpha: 1,
        overwrite: 0,
        colorize: Colors.red,
      );
    }
    myTweenList.tween(
      newValues,
      duration: 2,
      onUpdate: () {
        final values = myTweenList.value as List<double>;
        renderPositions(values);
      },
      ease: GEase.fastLinearToSlowEaseIn,
    );
  }

  void renderPositions(List<double> percents) {
    for (var i = 0; i < percents.length; ++i) {
      coords[i].y = percents[i] * graphH;
      dots.getChildAt(i).y = coords[i].y;
    }
    lines.graphics.clear();
    lines.graphics.lineStyle(1, Colors.black);
    lines.graphics.lineGradientStyle(
      GradientType.linear,
      [
        Colors.red.withOpacity(.8),
        Colors.blue.withOpacity(.8),
      ],
      ratios: [.1, 1],
    );
    bezierPoints.clear();
    bezierCurveThrough(lines.graphics, coords, .25, bezierPoints);

    filled.graphics.clear();
    filled.graphics.beginGradientFill(
      GradientType.linear,
      [
        Colors.blue.withOpacity(.4),
        Colors.red.withOpacity(0),
      ],
      ratios: [0.1, 1],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    bezierCurveThroughDraw(filled.graphics, bezierPoints);
    filled.graphics
        .lineTo(graphW, graphH)
        .lineTo(0, graphH)
        .lineTo(bezierPoints[0].x, bezierPoints[0].y)
        .endFill();
  }
}
