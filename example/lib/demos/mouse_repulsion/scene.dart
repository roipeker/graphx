import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class MouseRepulsionScene extends GSprite {
  var cols = 20;
  var rows = 20;
  var sep = 8.0;
  var dots = <GraphPoint>[];

  double spring = .015, stiff = .02, damp = .95, radius = 150.0;
  double radiusSq;

  double xoffset, yoffset;
  GSprite container;
  GShape mouseRadiusShape;

  double get sw => stage.stageWidth;
  double get sh => stage.stageHeight;

  @override
  void addedToStage() {
    mouseChildren = false;
    mouseRadiusShape = GShape();
    radiusSq = radius * radius;
    sep = 6;
    cols = 70;
    rows = 60;

    container = GSprite();
    addChild(container);

    // cols = (sw / sep).ceil() + 1;
    // rows = (sh / sep).ceil();
    var total = cols * rows;
    dots = List.generate(total, (index) {
      var d = GraphPoint();
      var idx = index % cols ?? 0;
      var idy = index ~/ cols ?? 0;
      if (index == 0) {
        d.tx = d.x = 0;
        d.ty = d.y = 0;
      } else {
        d.tx = d.x = idx * sep;
        d.ty = d.y = idy * sep;
      }
      return d;
    });

    mouseRadiusShape.graphics.lineStyle(1, Colors.red.withOpacity(.7));
    mouseRadiusShape.graphics.drawCircle(0, 0, radius).endFill();
    mouseRadiusShape.graphics.lineStyle(2, Colors.black);
    mouseRadiusShape.graphics.drawCircle(0, 0, radius - 1).endFill();
    mouseRadiusShape.graphics.lineStyle(1, Colors.red);
    mouseRadiusShape.graphics.drawCircle(0, 0, radius - 2).endFill();
  }

  @override
  void update(double delta) {
    super.update(delta);
    var mx = container.mouseX;
    var my = container.mouseY;
    container.x = (sw - cols * sep) / 2;
    container.y = (sh - rows * sep) / 2;

    if (stage.pointer.isDown) {
      radius = 60;
    } else {
      radius = 150;
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

    draw(container.graphics);
  }

  void draw(Graphics g) {
    g.clear();
    g.lineStyle(1, Colors.lightGreen.shade700);

    /// get the middle points to get a smooth cubic bezier...
    // var pa = dots[0];
    // var pz = dots.last;
    for (var i = 0; i < dots.length - 1; ++i) {
      var px = i % cols;
      var p0 = dots[i];
      var p1 = dots[i + 1];
      if (px == 0) {
        g.moveTo(p0.x, p0.y);
        continue;
      } else if (px == cols - 1) {
        continue;
      }
      g.curveTo(
        p0.x,
        p0.y,
        (p0.x + p1.x) / 2,
        (p0.y + p1.y) / 2,
      );
    }

    /// close the thing!
    g.endFill();
  }
}

class GraphPoint extends GShape {
  double tx = 0, ty = 0, vx = 0, vy = 0;

  GraphPoint() {
    mouseEnabled = false;
    _draw();
  }

  void _draw() => graphics.beginFill(kColorBlack).drawCircle(0, 0, 2).endFill();
}
