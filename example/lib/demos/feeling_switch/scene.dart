import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class FeelingSwitch extends GSprite {
  double get sw => stage!.stageWidth;

  double get sh => stage!.stageHeight;

  @override
  void addedToStage() {
    stage!.color = const Color(0xffF7F7F7);
    var container = GSprite();
    var tw = 100.0;
    var th = 40.0;
    var pill = GShape();
    var g = pill.graphics;
    g
        .beginFill(Color(0xffedeae8))
        .drawRoundRect(0, 0, tw, th, th / 2)
        .endFill();
    container.addChild(pill);

    var eyeRadius = 3.0;
    var gapy = 18.0;
    var gapx = th / 5;
    g
        .beginFill(Color(0xff71a745).withOpacity(.8))
        .drawCircle(gapy, eyeRadius + gapx, eyeRadius)
        .drawCircle(gapy, th - eyeRadius - gapx, eyeRadius)
        .endFill();
    g
        .beginFill(Color(0xffadadad))
        .drawCircle(tw - gapy, eyeRadius + gapx, eyeRadius)
        .drawCircle(tw - gapy, th - eyeRadius - gapx, eyeRadius)
        .endFill();

    var smile = GShape();
    /// for now, we avoid saving based on object bounds, as it will
    /// crop the line edges.
    smile.$useSaveLayerBounds = false ;
    smile.graphics.lineStyle(
      3,
      Color(0xff71a745).withOpacity(.8),
      true,
      StrokeCap.round,
    );
    smile.graphics.arc(0, 0, 10, deg2rad(-45 - 20.0), deg2rad(90 + 20.0 * 2));
    smile.graphics.endFill();
    smile.x = -tw / 4.3;
    container.addChild(smile);
    pill.alignPivot();

    var blur = GBlurFilter(6, 4);
    var pill2 = GShape();
    var g2 = pill2.graphics;
    g2
        .beginFill(Colors.black.withOpacity(.31))
        .drawRoundRect(0, 0, tw, th, th / 2)
        .endFill();
    pill2.filters = [blur];
    container.addChildAt(pill2, 0);
    pill2.alignPivot();
    pill2.scale = .9;
    pill2.rotation = -.11;
    pill2.setPosition(-3.0, 6.0);

    var isOn = true;
    toggle() {
      isOn = !isOn;
      if (isOn) {
        pill.tween(duration: .4, skewY: .05);
        pill2.tween(duration: .4, rotation: -.11, x: -3.0);
        smile.tween(
          duration: .76,
          x: -tw / 4.3,
          y: -1,
          skewY: .05,
          scaleY: 1.2,
          ease: GEase.easeOutSine,
          colorize: Color(0xff71A745).withOpacity(.8),
        );
      } else {
        pill.tween(duration: .4, skewY: -.05);
        pill2.tween(duration: .4, rotation: .11, x: 3.0);
        smile.tween(
          duration: .76,
          x: tw / 8,
          y: -1.0,
          scaleY: .8,
          skewY: -.05,
          ease: GEase.easeOutSine,
          colorize: Color(0xffaDADAD),
        );
      }
    }

    addChild(container);
    container.mouseChildren = false;
    container.onMouseClick.add((event) {
      toggle();
    });

    stage!.onResized.add(() {
      var sc = sw / tw;
      container.scale = sc;
      container.setPosition(sw / 2, sh / 2);
    });
  }
}
