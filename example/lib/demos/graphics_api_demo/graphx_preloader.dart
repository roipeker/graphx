import 'dart:ui';

import 'package:graphx/graphx.dart';


class GraphxPreloader extends Shape {
  double borderW = 4, radius = 40, progress = .5;

  void draw() {
    final startAngle = deg2rad(-90);
    final endAngle = deg2rad(360) * progress;
    graphics
        .clear()
        .lineStyle(borderW, 0xffffff, .07)
        .drawCircle(0, 0, radius)
        .endFill()
        .lineStyle(borderW, 0x5BB4C5, 1, true, StrokeCap.round)
        .arc(0, 0, radius, startAngle, endAngle)
        .endFill();
  }
}
