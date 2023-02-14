import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'ball.dart';

class CollisionScene extends GSprite {
  double get sw => stage!.stageWidth;
  double get sh => stage!.stageHeight;

  List lines = [];
  List<List<double>> points = <List<double>>[];
  List<Ball> balls = <Ball>[];
  double maxAge = 48;
  double nextBall = 0.0;
  final double releaseBallEvery = 2.0;

  @override
  void addedToStage() {
    _init();
  }

  @override
  void update(double t) {
    super.update(t);
    _update(t);
  }

  void _init() {
    List.generate(
      8,
      (index) {
        _addBall();
      },
    );
    stage!.onMouseDown.add(_onMouseDown);
  }

  void _update(double t) {
    // Periodically add another ball
    () {
      nextBall -= t;
      if (nextBall < 0) {
        _addBall();
        nextBall = releaseBallEvery;
      }
    }();

    // Update all balls
    for (Ball ball in balls) {
      _updateBall(ball, t);
    }

    // Draw lines
    graphics.clear();
    for (var i = 0; i < lines.length; i++) {
      graphics.lineStyle(5, const Color.fromARGB(255, 255, 255, 255));
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

      // Remove empty points.
      while (line.isNotEmpty && line[0][2] > maxAge) {
        line.removeAt(0);
      }
    }

    // Remove empty lines.
    while (lines.isNotEmpty && lines[0].length == 0) {
      lines.removeAt(0);
    }
  }

  void _addBall() {
    const random = Math.randomRange;
    var ball = Ball(
      x: random(0, sw),
      y: random(-50, -200),
      radius: random(20, 50),
      vx: random(-5, 5),
      vy: random(-10, 10),
      color: Math.randomList(Colors.primaries),
    );
    addChild(ball);
    balls.add(ball);
  }

  void _onMouseDown(input) {
    stage!.onMouseUp.addOnce((input) => stage!.onMouseMove.removeAll());
    stage!.onMouseMove.add((input) => points.add([mouseX, mouseY, 0.0]));
    points = <List<double>>[
      [mouseX, mouseY, 0.0]
    ];
    lines.add(points);
  }

  void _updateBall(
    Ball ball,
    double t,
  ) {
    // Drag and gravity
    ball.vx += t * 0.01;
    ball.vy += t * 3;

    // Position
    ball.x += ball.vx;
    ball.y += ball.vy;

    // Make it bounce back if it hits and goes up
    if (ball.y < -200) {
      ball.y = -200;
      ball.vy *= -1;
    }

    // Reset at bottom
    if (ball.y - ball.radius > sh) {
      ball.x = Math.randomRange(0, sw);
      ball.y = -100;
      ball.vx = Math.randomRange(-5, 5);
      ball.vy = 0;
    }

    // Bouce of screen edges
    if (ball.x + ball.radius > sw) {
      ball.x = sw - ball.radius;
      ball.vx *= -1;
    }

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

          const double maxVelocity = 8.0;

          ball.vx = () {
            double newVx = ball.vx + (nx - ball.x) * 2;
            if (newVx < -maxVelocity) {
              newVx = -maxVelocity;
            } else if (newVx > maxVelocity) {
              newVx = maxVelocity;
            }
            return newVx;
          }();

          ball.vy = () {
            double newVy = ball.vy + (ny - ball.y) * 2;
            if (newVy < -maxVelocity) {
              newVy = -maxVelocity;
            } else if (newVy > maxVelocity) {
              newVy = maxVelocity;
            }
            return newVy;
          }();

          ball.x = nx;
          ball.y = ny;
        }
      }
    }
  }
}
