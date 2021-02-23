import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class MyButton extends GSprite {
  double w, h;
  GShape bg, border1, border2;
  GIcon successIco;

  GText label;
  final Color mainColor = const Color(0xff58A993);
  final Color greyColor = const Color(0xffE3E3E3);
  final tweenWidth = 0.0.twn;
  double currentW;
  double percentLoaded = 0.0;
  double lineThickness = 4;

  MyButton(this.w, this.h) {
    _init();
  }

  void _init() {
    currentW = w;
    useCursor = true;
    bg = GShape();
    border1 = GShape();
    border2 = GShape();
    addChild(bg);
    addChild(border1);
    addChild(border2);
    bg.setPosition(w / 2, h / 2);
    border1.setPosition(w / 2, h / 2);
    border2.setPosition(w / 2, h / 2);
    label = GText.build(
      text: 'Submit',
      color: mainColor,
      fontSize: 25,
      letterSpacing: .1,
      fontWeight: FontWeight.w500,
    );
    label.alignPivot();
    label.setPosition(w / 2, h / 2);
    addChild(label);
    successIco = GIcon(Icons.check, Colors.white, 48);
    addChild(successIco);
    successIco.alignPivot();
    successIco.setPosition(w / 2, h / 2);
    successIco.setProps(scale: .5, alpha: 0);
    draw();
    onMouseDown.add(_onMousePress);
    onMouseClick.add(_onTap);
  }

  void _onMousePress(event) {
    bg.tween(duration: .3, colorize: mainColor);
    label.tween(duration: .2, colorize: Colors.white, scale: .9);
    stage.onMouseUp.addOnce(_onMouseUp);
  }

  void _onMouseUp(event) {
    bg.tween(duration: .3, colorize: Colors.white);
    label.tween(duration: .3, colorize: Colors.white.withOpacity(0), scale: 1);
  }

  void _onTap(event) {
    setToPreloader();
  }

  void setToPreloader() {
    mouseEnabled = false;
    tweenWidth.value = w;
    // final tweenWidth = w.twn;
    tweenWidth.tween(
      h,
      duration: .9,
      onUpdate: () {
        currentW = tweenWidth.value;
        draw();
      },
      onComplete: setToProgress,
      ease: GEase.easeInOutExpo,
    );
    border1.tween(duration: .7, colorize: greyColor, overwrite: 0);
    label.visible = false;
  }

  void setToProgress() {
    percentLoaded = 0;
    final tweenProgress = percentLoaded.twn;
    tweenProgress.tween(
      1.0,
      duration: 1.3,
      onUpdate: () {
        percentLoaded = tweenProgress.value;
        drawPercent();
      },
      onComplete: setToSuccess,
      ease: GEase.fastLinearToSlowEaseIn,
    );
  }

  void setToSuccess() {
    tweenWidth.tween(
      w,
      duration: .4,
      onUpdate: () {
        currentW = tweenWidth.value;
        draw();
      },
      ease: GEase.easeOutExpo,
    );
    bg.tween(duration: .3, colorize: mainColor);
    border1.tween(duration: .2, colorize: greyColor.withOpacity(0));
    border2.graphics.clear();
    successIco.tween(
      duration: .7,
      delay: .4,
      scale: 1,
      alpha: 1,
      ease: GEase.easeOutBack,
      onComplete: setToStart,
    );
  }

  void setToStart() {
    label.visible = true;
    successIco.tween(
        duration: .5,
        scale: .5,
        alpha: 0,
        onComplete: () {
          mouseEnabled = true;
        });
    bg.tween(duration: .3, colorize: Colors.white);
  }

  void drawPercent() {
    var radius = h / 2;
    border2.graphics
        .clear()
        .lineStyle(lineThickness, mainColor)
        .arc(0, 0, radius, -Math.PI / 2, Math.PI_2 * percentLoaded)
        .endFill();
  }

  void draw() {
    bg.graphics
        .clear()
        .beginFill(Colors.white)
        .drawRoundRect(-currentW / 2, -h / 2, currentW, h, h / 2)
        .endFill();
    var lineWOffset = lineThickness / 2;
    border1.graphics
        .clear()
        .beginFill(kColorTransparent)
        .drawRoundRect(
          -currentW / 2 - lineWOffset,
          -h / 2 - lineWOffset,
          currentW + lineWOffset * 2,
          h + lineWOffset * 2,
          h / 2,
        )
        .endFill()
        .lineStyle(lineThickness, mainColor)
        .drawRoundRect(-currentW / 2, -h / 2, currentW, h, h / 2)
        .endFill();
    bg.alignPivot();
    border1.alignPivot();
  }
}
