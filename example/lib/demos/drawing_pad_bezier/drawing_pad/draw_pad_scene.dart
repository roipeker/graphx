import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'pad.dart';

class DrawPadScene extends GSprite {
  int colorCount = 0;

  double get sw => stage.stageWidth;

  double get sh => stage.stageHeight;

  double targetRot = 0;
  double opacity = 1.0;

  double minRad = 2;
  double maxRad = 10.0;
  double minR = 2;
  double maxR = 2;

  @override
  void addedToStage() async {
    stage.onHotReload.addOnce(() {
      stage.onMouseScroll.removeAll();
      stage.onMouseMove.removeAll();
      mps.offAll('color');
      mps.offAll('clear');
    });
    var pad = Pad(w: sw, h: sh);
    pad.backgroundColor = Colors.transparent;
    pad.clear();
    pad.penColor = Colors.green;
    addChild(pad);

    pad.onBegin = GMouse.hide;
    pad.onEnd = GMouse.show;

    stage.onMouseScroll.add((event) {
      var dir = event.scrollDelta.y;
      if (dir == 0) return;
      dir = dir < 0 ? 1 : -1;
      if (stage.keyboard.isShiftPressed) {
        pad.minW += (dir * .1);
        pad.minW = pad.minW.clamp(minRad, maxRad);
      } else {
        pad.maxW += (dir * .1);
        pad.maxW = pad.maxW.clamp(minRad, maxRad);
      }
    });
    stage.onResized.add(() => pad.resize(sw, sh));

    pad.minW = .2;
    pad.maxW = 12.2;
    mps.on('alpha', (double alpha) {
      opacity = alpha;
      pad.canvas.alpha = alpha;
    });
    mps.on('color', (Color color) {
      pad.penColor = color;
    });
    mps.on('clear', () {
      pad.clear();
    });
    mps.emit1('color', Colors.primaries.first);
  }
}
