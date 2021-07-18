import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

abstract class GameObj extends GShape {
  double w = 0, h = 0;
  Color? color;

  void init(double w, double h, Color? color) {
    this.w = w;
    this.h = h;
    this.color = color;
    _draw();
  }

  _draw();
}

class Ball extends GameObj {
  double speed = 1, vx = 0, vy = 0;

  double get radius => w / 2;

  bool get isStopped => vx == 0;

  void setVelocity(double value) {
    vx = vy = value;
  }

  @override
  void _draw() {
    graphics.beginFill(color!).drawCircle(0, 0, w / 2).endFill();
  }
}

class Paddle extends GameObj {
  double vx = 0;
  double speed = 2.5;

  @override
  void _draw() {
    graphics.beginFill(color!).drawRect(0, 0, w, h).endFill();
  }
}

class Brick extends GameObj {
  int points = 1;

  @override
  void _draw() {
    graphics.beginFill(color!).drawRect(0, 0, w, h).endFill();
  }
}
