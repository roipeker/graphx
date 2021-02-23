import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

final stageColor = Colors.grey.shade800;

class LinedButtonScene extends GSprite {
  @override
  void addedToStage() {
    stage.color = stageColor;
    var btn = LineButton(120, 60);
    addChild(btn);
    btn.x = stage.stageWidth / 2;
    btn.y = stage.stageHeight / 2;
  }
}

class LineButton extends GSprite {
  double w, h;
  Path _oriPath;
  PathMetric _metrics;

  final _tweenTf = 0.0.twn;
  final _tweenBg1 = 0.0.twn;
  final _tweenBg2 = 0.0.twn;
  final _stageColorTween = stageColor.twn;

  GShape bg;
  GShape bg2;
  GShape bgBounds;
  GText tf;
  bool isOver = false;

  LineButton([this.w = 100, this.h = 50]) {
    _init();
  }

  void _init() {
    bg = GShape();
    bg.graphics.lineStyle(.4, Colors.white).drawRect(0, 0, w, h).endFill();

    bgBounds = GShape();
    bgBounds.graphics.beginFill(kColorBlack).drawRect(0, 0, w, h).endFill();
    bgBounds.alpha = 0.001;

    bg2 = GShape();

    _oriPath = Path.from(bg.graphics.getPaths());
    _metrics = _oriPath.computeMetrics(forceClosed: true).first;

    tf = GText(
      text: 'GRAPHX',
      textStyle: TextStyle(
        letterSpacing: 1,
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w100,
      ),
    );

    addChild(bg);
    addChild(bg2);
    addChild(bgBounds);
    addChild(tf);

    // mouseChildren = false;
    tf.mouseEnabled = bg.mouseEnabled = bg2.mouseEnabled = false;
    // bgBounds.mouseUseShape = false;
    bgBounds.mouseEnabled = true;
    bgBounds.useCursor = true;

    bgBounds.onMouseDown.add((e) {
      GTween.killTweensOf(tf);
      GTween.killTweensOf(_openLink);
      tf.tween(duration: .3, scale: .88);
      stage.onMouseUp.addOnce((e) {
        tf.tween(
          duration: .5,
          scale: 1,
          ease: GEase.elasticOut,
        );
        if (isOver) {
          GTween.delayedCall(1.2, _openLink);
        }
      });
    });
    bgBounds.onMouseOver.add((e) {
      _tweenTo(true);
      isOver = true;
      bgBounds.onMouseOut.addOnce((e) {
        isOver = false;
        _tweenTo(false);
      });
    });
    alignPivot();
    tf.alignPivot();
    tf.setPosition(w / 2, h / 2);
  }

  void _openLink() {
    trace('open url: "https://pub.dev/packages/graphx"');
  }

  void _tweenTo(bool enters) {
    [
      _tweenTf,
      _tweenBg1,
      _tweenBg2,
      _stageColorTween,
    ].forEach(GTween.killTweensOf);
    var value = enters ? 1.0 : 0.0;

    /// tween background color.
    _stageColorTween.target = _stageColorTween.value;
    _stageColorTween.tween(
      enters ? Colors.grey.shade900 : stageColor,
      ease: GEase.easeOutSine,
      duration: 1.1,
      onUpdate: () => stage.color = _stageColorTween.value,
    );

    _tweenTf.tween(value, duration: .4, onUpdate: _drawText);
    _tweenBg1.tween(
      value,
      duration: .5,
      onUpdate: _drawBg1,
    );
    _tweenBg2.tween(
      value,
      duration: enters ? 1.2 : .6,
      delay: enters ? 0.2 : 0.0,
      onUpdate: _drawBg2,
      ease: GEase.easeOutExpo,
    );
  }

  void _setStyle({
    FontWeight fontWeight,
    double letterSpacing,
    Color color,
    double fontSize,
  }) {
    tf.setTextStyle(
      TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color,
        letterSpacing: letterSpacing,
      ),
    );
  }

  void _drawBg1() {
    var percent = _tweenBg1.value;
    var len = _metrics.length * (1 - percent);
    var newPath = _metrics.extractPath(0, len);
    bg.graphics.clear();
    bg.graphics.lineStyle(.4 + (percent * 2.5), Colors.white);
    bg.graphics.drawPath(newPath);
    bg.graphics.endFill();
  }

  void _drawBg2() {
    var from = _metrics.length - 90 * _tweenBg2.value;
    var to = from + 20;
    var newPath = _metrics.extractPath(from, to);
    bg2.graphics.clear();
    bg2.graphics.lineStyle(2 + _tweenBg2.value * 1, Colors.white);
    bg2.graphics.drawPath(newPath);
    bg2.graphics.endFill();
  }

  void _drawText() {
    var variants = FontWeight.values;
    var idx = (_tweenTf.value * (variants.length - 2)).round();
    var weight = variants[idx];
    _setStyle(
      fontWeight: weight,
      letterSpacing: _tweenTf.value,
      color: Colors.white,
      fontSize: 18,
    );
    tf.alignPivot();
  }
}
