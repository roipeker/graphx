/// roipeker2020
///
/// As other samples, use the `SceneBuilderWidget`.
///
/// web demo:
/// https://roi-graphx-jelly-green.surge.sh
///
/// source:
/// https://gist.github.com/roipeker/dbf792b862ad8dfb526c227c2e1d4ad9
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class JellyDotsScene extends GSprite {
  List<Dot>? points;
  int totalPoints = 120;
  double size = 18;
  double mouseRadius = 80.0, mouseStrength = .06, stiffness = .05;
  bool outlineJelly = false;

  double get sw => stage!.stageWidth;

  double get sh => stage!.stageHeight;

  void _toggleVisible(Dot d) => d.visible = !d.visible;

  @override
  void addedToStage() {
    stage!.keyboard.onDown.add((event) {
      if (event.isKey(LogicalKeyboardKey.keyD)) {
        points!.forEach(_toggleVisible);
      } else if (event.isKey(LogicalKeyboardKey.keyO)) {
        outlineJelly = !outlineJelly;
      } else if (event.isKey(LogicalKeyboardKey.keyR)) {
        for (var dot in points!) {
          dot.x = dot.px = dot.ox;
          dot.y = dot.py = dot.oy;
          dot.vx = dot.vy = 0;
        }
      }
    });
    points = List.generate(totalPoints, (i) {
      var angle = MathUtils.pi2 / totalPoints * i;
      var dot = Dot(
        px: sw / 2 + Math.cos(angle) * 150 + Math.randomRange(-5, 5),
        py: sh / 2 + Math.sin(angle) * 150 + Math.randomRange(-5, 5),
      );
      dot.ox = dot.px;
      dot.oy = dot.py;
      dot.visible = false;
      addChild(dot);
      return dot;
    });
  }

  @override
  void dispose() {
    super.dispose();
    points?.clear();
  }

  @override
  void update(double delta) {
    super.update(delta);
    if (stage!.pointer!.isDown) {
      size = 20;
      stiffness = .15;
    } else {
      size = 15;
      stiffness = .05;
    }
    for (var i = 0; i < totalPoints - 1; ++i) {
      var p0 = points![i];
      for (var j = i + 1; j < totalPoints; ++j) {
        var p1 = points![j];
        compare(p0, p1, j == i + 1);
      }
    }
    compare(points![totalPoints - 1], points![0], true);
    updatePoints();
    draw(graphics);
  }

  void updatePoints() {
    /// save touch coordinates, to avoid the matrix transformation.
    var mx = mouseX;
    var my = mouseY;
    for (var dot in points!) {
      var dx = dot.x - mx;
      var dy = dot.y - my;
      var dist = Math.sqrt(dx * dx + dy * dy);
      if (dist < mouseRadius) {
        var tx = mx + dx / dist * mouseRadius;
        var ty = my + dy / dist * mouseRadius;

        /// the good old Euclidean :) ... distance based easing
        dot.vx += (tx - dot.x) * mouseStrength;
        dot.vy += (ty - dot.y) * mouseStrength;
      }
      dot.x += dot.vx;
      dot.y += dot.vy;
      dot.vx *= dot.friction;
      dot.vy *= dot.friction;
    }
  }

  void compare(Dot p0, Dot p1, [bool isSibling = false]) {
    var dx = p1.x - p0.x;
    var dy = p1.y - p0.y;
    var dist = Math.sqrt(dx * dx + dy * dy);
    if (isSibling) {
      var tx = p0.x + dx / dist * size;
      var ty = p0.y + dy / dist * size;
      var ax = (tx - p1.x) * stiffness;
      var ay = (ty - p1.y) * stiffness;
      p1.vx += ax;
      p1.vy += ay;
      p0.vx -= ax;
      p0.vy -= ay;
    } else if (dist < size * 2) {
      var tx = p0.x + dx / dist * size * 2;
      var ty = p0.y + dy / dist * size * 2;
      var ax = (tx - p1.x) * stiffness;
      var ay = (ty - p1.y) * stiffness;
      p1.vx += ax;
      p1.vy += ay;
      p0.vx -= ax;
      p0.vy -= ay;
    }
  }

  void draw(Graphics g) {
    g.clear();
    g.beginFill(Colors.lightGreen);
    if (outlineJelly) {
      g.lineStyle(3, Colors.lightGreen.shade700);
    }

    /// get the middle points to get a smooth cubic bezier...
    var pa = points![0];
    var pz = points!.last;
    var mid1x = (pz.x + pa.x) / 2;
    var mid1y = (pz.y + pa.y) / 2;

    g.moveTo(mid1x, mid1y);
    for (var i = 0; i < points!.length - 1; ++i) {
      var p0 = points![i];
      var p1 = points![i + 1];
      g.curveTo(
        p0.x,
        p0.y,
        (p0.x + p1.x) / 2,
        (p0.y + p1.y) / 2,
      );
    }

    /// close the thing!
    g.curveTo(pz.x, pz.y, mid1x, mid1y);
    g.endFill();
  }
}

/// dot (point) reference.
class Dot extends GShape {
  double ox = 0, oy = 0;
  double px = 0, py = 0, vx = 0, vy = 0, friction = .9;

  Dot({required this.px, required this.py}) {
    graphics
        .beginFill(Colors.yellowAccent)
        .lineStyle(2, Colors.green.withOpacity(.5))
        .drawCircle(0, 0, 4)
        .endFill();
    setPosition(px, py);
  }
}
