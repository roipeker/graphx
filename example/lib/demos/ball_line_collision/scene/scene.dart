/// roipeker 2020
///
/// As other samples, use the `SceneBuilderWidget`.
///
/// web demo: https://roi-graphx-balls-collision.surge.sh/#/

import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'ball.dart';

class CollisionScene extends GSprite {
  double get sw => stage!.stageWidth;

  double get sh => stage!.stageHeight;

  /// lazy with the types :P
  List lines = [];
  List<List<double>> points = <List<double>>[];
  List<Ball> balls = <Ball>[];
  double maxAge = 200;

  @override
  void addedToStage() {
    const random = Math.randomRange;
    List.generate(10, (index) {
      var ball = Ball(
        x: random(0, sw),
        y: random(-50, -200),
        radius: random(20, 50),
        vx: random(-5, 5),
        vy: 0,
        color: Math.randomList(Colors.primaries),
      );
      addChild(ball);
      balls.add(ball);
    });
    stage!.onMouseDown.add(_onMouseDown);
  }

  void _onMouseDown(input) {
    stage!.onMouseUp.addOnce((input) => stage!.onMouseMove.removeAll());
    stage!.onMouseMove.add((input) => points.add([mouseX, mouseY, 0.0]));
    points = <List<double>>[
      [mouseX, mouseY, 0.0]
    ];
    lines.add(points);
  }

  @override
  void update(double t) {
    super.update(t);
    balls.forEach(updateBall);
    graphics.clear();
    for (var i = 0; i < lines.length; i++) {
      graphics.lineStyle(3, const Color(0xff212121));
      var line = lines[i];
      for (var j = 0; j < line.length; j++) {
        var p = line[j];
        p[2]++;
        if (j == 0) {
          graphics.moveTo(p[0], p[1]);
        } else {
          graphics.lineTo(p[0], p[1]);
        }
      }

      /// remove  empty points.
      while (line.isNotEmpty && line[0][2] > maxAge) {
        line.removeAt(0);
      }
    }

    /// remove empty lines.
    while (lines.isNotEmpty && lines[0].length == 0) {
      lines.removeAt(0);
    }
  }

  void updateBall(Ball ball) {
    ball.vy += 0.1;
    ball.x += ball.vx;
    ball.y += ball.vy;

    /// make it bounce back if it hits and goes up
    if (ball.y < -200) {
      ball.y = -200;
      ball.vy *= -1;
    }

    /// if it went down the windows size, reset position and speed.
    if (ball.y - ball.radius > sh) {
      ball.x = Math.randomRange(0, sw);
      ball.y = -100;
      ball.vy = ball.vx = 0;
    }

    /// make it hit the wall on the right side.
    if (ball.x + ball.radius > sw) {
      ball.x = sw - ball.radius;
      ball.vx *= -1;
    }

    /// make it hit the wall on the left side.
    if (ball.x - ball.radius < 0) {
      ball.x = ball.radius;
      ball.vx *= -1;
    }

    for (var i = 0; i < lines.length; i++) {
      var line = lines[i];
      for (var j = 0; j < line.length; j++) {
        var p = line[j];
        var px = p[0];
        var py = p[1];
        var dx = ball.x - px;
        var dy = ball.y - py;
        var dist = Math.sqrt(dx * dx + dy * dy);

        /// check if the distance between the circle and the points is less than
        /// the circle radius, is a collision.
        if (dist < ball.radius) {
          /// move the ball along the line...
          var nx = px + dx / dist * ball.radius;
          var ny = py + dy / dist * ball.radius;
          ball.vx += (nx - ball.x) * 2;
          ball.vy += (ny - ball.y) * 2;
          ball.x = nx;
          ball.y = ny;
        }
      }
    }
  }
}
