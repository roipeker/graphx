
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class TriangleGrid extends GShape {
  double res;
  int rows, cols;
  bool debugTriangles = false;

  GTexture texture;

  TriangleGrid({
    GSprite doc,
    this.res = 10,
    this.cols = 5,
    this.rows = 5,
  }) {
    doc?.addChild(this);
    makeTriangles();
    draw();
  }

  List<double> vertices;
  List<double> uvData;
  List<int> indices;

  void draw() {
    graphics.clear();
    if (texture != null) {
      graphics
          .beginBitmapFill(texture, null, false, true)
          .drawTriangles(vertices, indices, uvData)
          .endFill();
    }
    if (debugTriangles) {
      graphics
          .lineStyle(0, Colors.white30)
          .drawTriangles(vertices, indices, uvData)
          .endFill();
    }
  }

  void makeTriangles() {
    vertices = [];
    uvData = [];
    indices = [];
    var total = rows * cols;
    for (var c = 0; c < total; ++c) {
      var i = c ~/ cols;
      var j = c % cols;
      vertices.addAll([j * res, i * res]);
      uvData.addAll([
        j / (cols - 1),
        i / (rows - 1),
      ]);

      if (i < rows - 1 && j < cols - 1) {
        ///first tri
        indices.addAll([i * cols + j, i * cols + j + 1, (i + 1) * cols + j]);

        ///first tri
        indices.addAll(
            [i * cols + j + 1, (i + 1) * cols + j + 1, (i + 1) * cols + j]);
      }
    }
  }
}
