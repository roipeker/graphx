
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import '../data.dart';

class DotButton extends GSprite {
  GShape bg, bgOver;

  DotDataModel model;

  void setValue(double value) {
    model = DotDataModel();
    model.value = value;
  }

  @override
  void addedToStage() {
    bg = GShape();

    bgOver = GShape();
    graphics
        .beginFill(Colors.black.withOpacity(.01))
        .drawCircle(0, 0, 20)
        .endFill();
    bg.graphics
        .beginFill(Colors.orange)
        .lineStyle(0, Colors.white)
        .drawCircle(0, 0, 3)
        .endFill()
        .endFill();

    bgOver.graphics
        .beginFill(Colors.orange.withOpacity(.5))
        .drawCircle(0, 0, 3)
        .endFill();

    addChild(bgOver);
    addChild(bg);

    mouseChildren = false;
    onMouseOver.add((event) {
      bgOver.tween(duration: .5, scale: 2);

      final rect = bg.getBounds(stage);
      model.coordinate.setTo(
        rect.x + rect.width / 2,
        rect.y + rect.height / 2,
      );
      mps.emit1('chartHover', model);
      onMouseOut.addOnce((event) {
        bgOver.tween(duration: .65, scale: 1);
      });
    });
  }
}
