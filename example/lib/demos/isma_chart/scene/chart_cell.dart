import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import '../data.dart';

class ChartTableCell extends GSprite {
  double w = 0.0, h = 0.0;
  double cellH = 12;
  late double cellW;

  ChartTableCell([GSprite? doc]) {
    doc?.addChild(this);
  }

  List<int> colValues = [];

  void drawData() {
    cellW = w / colValues.length;
    for (var i = 0; i < colValues.length; ++i) {
      var value = colValues[i];
      var cell = GSprite();
      addChild(cell);
      cell.graphics
          .lineStyle(0, const Color(0xffcccccc))
          .drawRect(0, 0, cellW, cellH)
          .endFill();
      var tf = GText(
        text: '$value',
        width: cellW,
        textStyle: valueTextStyle,
        paragraphStyle: ParagraphStyle(textAlign: TextAlign.center),
      );
      tf.validate();
      tf.y = (cellH / 2 - tf.textHeight / 2);
      cell.addChild(tf);
      cell.x = i * cellW;
    }
  }

  void initDraw({required double w, required double h}) {
    this.w = w;
    this.h = h;
    graphics
        .beginFill(Colors.blue.withOpacity(.001))
        .drawRect(0, 0, w, h)
        .endFill();
  }
}
