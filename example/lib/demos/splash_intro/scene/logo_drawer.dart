/// copyright roipeker 2020
///
/// web demo:
/// https://roi-graphx-splash.surge.sh
///
/// source code (gists):
/// https://gist.github.com/roipeker/37374272d15539aa60c2bdc39001a035
///
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphx/graphx.dart';

/// GSprite that will hold a SVG path drawing with a
/// filled and outlined version... and the ability to partially
/// draw the outlined based on percentage.
class LogoDrawer extends GSprite {
  late List<PathMetric> _metricsList;
  late Path _rootPath;

  late GShape line;
  late GShape fill;

  LogoDrawer() {
    _init();
  }

  void _init() {
    line = GShape();
    fill = GShape();
    addChild(line);
    addChild(fill);
    fill.visible = false;
  }

  Future<void> parseSvg(String word) async {
    var svgElement = await SvgUtils.svgStringToSvgDrawable(word);
    final letters = <Path>[];
    if (svgElement.hasDrawableContent) {
      for (var c in svgElement.children) {
        if (c is DrawableShape) {
          letters.add(c.path);
        }
      }
    }
    _rootPath = letters.reduce(
      (path1, path2) => Path.combine(PathOperation.union, path1, path2),
    );
    _metricsList = _rootPath.computeMetrics(forceClosed: false).toList();
    drawPercent(1);
  }

  void drawPercent(double? percent) {
    line.graphics.clear();
    line.graphics.lineStyle(1, Colors.white);
    for (var m in _metricsList) {
      line.graphics.drawPath(m.extractPath(0, m.length * percent!));
    }
    line.graphics.endFill();
  }

  void drawFill(Color color) {
    fill.graphics.clear();
    fill.graphics.beginFill(color);
    fill.graphics.drawPath(_rootPath);
    fill.graphics.endFill();
  }
}
