import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'dot_button.dart';

class Chart extends GSprite {
  double w, h;
  int cols, rows;
  GShape chartLine;

  Chart([GSprite doc]) {
    doc?.addChild(this);
    chartLine = GShape();
    addChild(chartLine);
  }

  double rowsSep;

  void initDraw({
    double w,
    double h,
    int cols,
    int rows,
    // double rowsSep,
  }) {
    this.w = w;
    this.h = h;
    // this.rowsSep = rowsSep;
    this.rows = rows;
    this.cols = cols;
    graphics
        .beginFill(Colors.purple.withOpacity(.001))
        .drawRect(0, 0, w, h)
        .endFill();
    _drawGrid();
  }

  double maxValueY;
  double colSep, rowSep, colOffset;

  void _drawGrid() {
    colSep = w / cols;
    rowSep = h / (rows - 1);
    colOffset = colSep / 2;

    graphics.lineStyle(0, Colors.black.withOpacity(.14));

    /// columns.
    for (var i = 0; i < cols; ++i) {
      var lineX = colOffset + i * colSep;
      graphics.moveTo(lineX, 0).lineTo(lineX, h);
    }

    /// rows.
    for (var i = 0; i < rows - 1; ++i) {
      var lineY = i * rowSep;
      graphics.moveTo(0, lineY).lineTo(w, lineY);
    }
    graphics.endFill();
  }

  void drawData(List<double> cfrData) {
    final g = chartLine.graphics;
    g.lineStyle(2, Colors.orange);
    for (var i = 0; i < cfrData.length; ++i) {
      var value = cfrData[i];
      var percent = value / maxValueY;
      // trace('value is :', value, ' percent:', percent);
      var lineX = colOffset + i * colSep;
      var lineY = h - percent * h;
      if (i == 0) {
        g.moveTo(lineX, lineY);
      } else {
        g.lineTo(lineX, lineY);
      }
      var dot = DotButton();
      dot.setValue(cfrData[i]);
      addChild(dot);
      dot.setPosition(lineX, lineY);
    }
    g.endFill();
  }
}
