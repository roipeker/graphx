import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'point.dart';
import 'tri_grid.dart';

class DrawTriangleGridScene extends GSprite {
  static const int res = 3;
  static const double targetRadius = 120;

  /// draw triangle parameters.
  List<double> vertices = <double>[];
  List<int> indices = <int>[];
  List<double> uvts = <double>[];

  double sep = 50 / res;
  int cols = 5 * res, rows = 4 * res;
  double spring = .0025, stiff = .02, damp = .98, radius = targetRadius;
  late double radiusSq;

  late List<GraphPoint> dots;
  late TriangleGrid triGrid;
  late GSprite container;
  bool inited = false;
  double textureW = 0, textureH = 0;

  @override
  Future<void> addedToStage() async {
    stage!.color = Colors.grey.shade800;

    container = GSprite();
    addChild(container);
    mouseChildren = false;
    late GTexture texture;
    try {
      texture = await ResourceLoader.loadTexture(
          'assets/trigrid/cute_dog.png', 1, 'dog');
    } catch(e) {
      throw "We have an error loading the image $e";
    }
    textureW = texture.width!;
    textureH = texture.height!;
    cols = textureW ~/ sep;
    rows = textureH ~/ sep;
    var total = cols * rows;

    /// these are the points that we MOVE to update the grid.
    dots = List.generate(total, (index) {
      var d = GraphPoint();

      /// uncomment this to see the DOTS.
      // container.addChild(d);
      var idx = index % cols;
      var idy = index ~/ cols;
      if (index == 0) {
        d.tx = d.x = 0;
        d.ty = d.y = 0;
      } else {
        d.tx = d.x = idx * sep;
        d.ty = d.y = idy * sep;
      }
      return d;
    });

    triGrid = TriangleGrid(res: sep, cols: cols, rows: rows);

    /// show the triangles lines
    triGrid.debugTriangles = false;
    container.addChildAt(triGrid, 0);
    triGrid.texture = texture;
    triGrid.draw();
    inited = true;
  }

  void adjustContainer() {
    /// resize container based on the image dimensions.
    var tw = textureW;
    var th = textureH;
    var scaleTo = stage!.stageHeight / th;
    container.y = 0;
    container.scale = scaleTo;
    container.x = (stage!.stageWidth - (tw * scaleTo)) / 2;
  }

  @override
  void update(double delta) {
    super.update(delta);
    if (!inited) return;
    // return;
    adjustContainer();
    updatePoints();
    renderPoints();
  }

  void renderPoints() {
    var ver = triGrid.vertices;
    var j = 0;
    for (var i = 0; i < dots.length; ++i) {
      var d = dots[i];
      ver[j++] = d.x;
      ver[j++] = d.y;
    }
    triGrid.draw();
  }

  void updatePoints() {
    var mx = container.mouseX;
    var my = container.mouseY;

    // container.x = (sw - cols * sep) / 2;
    // container.y = (sh - rows * sep) / 2;

    if (stage!.pointer!.isDown) {
      radius = -targetRadius / 4;
    } else {
      radius = targetRadius;
    }
    radiusSq = radius * radius;

    for (var i = 0; i < dots.length; ++i) {
      var d = dots[i];
      var dx = d.x - mx;
      var dy = d.y - my;
      var dsq = dx * dx + dy * dy;
      if (dsq < radiusSq) {
        var dist = Math.sqrt(dsq);
        var tx = mx + dx / dist * radius;
        var ty = my + dy / dist * radius;
        d.vx += (tx - d.x) * spring;
        d.vy += (ty - d.y) * spring;
      }
      d.vx += (d.tx - d.x) * stiff;
      d.vy += (d.ty - d.y) * stiff;
      d.vx *= damp;
      d.vy *= damp;
      d.x += d.vx;
      d.y += d.vy;
      if (d.x.isNaN) d.x = 0;
      if (d.y.isNaN) d.y = 0;
    }
  }

  void drawImage() {}
}
