import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class GraphPoint extends GShape {
  double tx = 0, ty = 0, vx = 0, vy = 0;

  GraphPoint() {
    mouseEnabled = false;
    _draw();
  }

  void _draw() {
    graphics
        .beginFill(Colors.yellowAccent.withOpacity(.35))
        .drawCircle(0, 0, 1)
        .endFill();
  }
}
