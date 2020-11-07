import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class MyBox extends Shape {
  final double size;

  MyBox({this.size = 40}) {
    _init();
  }

  void _init() {
    graphics.beginFill(Colors.brown.shade300.value);

    /// we draw the rectangle from TOP LEFT (x=0,y=0).
    graphics.drawRect(0, 0, size, size).endFill();
    graphics.lineStyle(2, Colors.brown.shade500.value);
    // make 4 lines.
    var numLines = 4;
    var lineSep = size / numLines;
    for (var i = 0; i <= numLines; ++i) {
      graphics.moveTo(lineSep * i, 0);
      graphics.lineTo(lineSep * i, size);
    }
  }
}
