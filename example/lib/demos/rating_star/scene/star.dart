import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'rating_scene.dart';

class Star extends GSprite {
  double starSize = 40;
  double dotSize = 10;
  bool active = false;

  GShape _star;

  GSprite _broken;

  GShape _dot;

  Star() {
    _initUi();
    mouseChildren = false;
  }

  static GTexture _tx1;
  static GTexture _tx2;

  Future<bool> createTemplate() async {
    var st = GShape();
    // addChild(st);
    st.graphics.copyFrom(_star.graphics);

    var m1 = GShape();
    // addChild(m1);

    var s2 = starSize / 1.8;
    m1.graphics
        // .beginHole()
        .beginFill(Colors.red.withOpacity(.5))
        .moveTo(-s2, s2 * .7)
        .lineTo(s2, -s2)
        .lineTo(-s2 * 1, -s2)
        .closePath()
        .endFill();

    st.mask = m1;
    _tx1 = await st.createImageTexture(true);

    st.maskInverted = true;
    _tx2 = await st.createImageTexture(true, 2);
    return true;
  }

  void _initUi() {
    _star = GShape();
    _dot = GShape();

    _dot.graphics
        .beginFill(kUnselectedSColor)
        .drawCircle(0, 0, dotSize / 2)
        .endFill();

    _star.graphics
        .beginFill(kStarColor)
        .drawStar(0, 0, 5, starSize / 2)
        .endFill();

    addChild(_dot);
    addChild(_star);

    _createBrokenStar();

    _star.visible = false;

    onMouseDown.add(_handleDown);
  }

  Future<void> _createBrokenStar() async {
    if (_tx1 == null) {
      await createTemplate();
    }
    _broken = GSprite();
    addChild(_broken);
    var bmp1 = GBitmap(_tx1);
    var bmp2 = GBitmap(_tx2);
    // bmp1.nativePaint.filterQuality = FilterQuality.medium;
    // bmp2.nativePaint.filterQuality = FilterQuality.medium;
    bmp1.pivotX = 11;
    bmp1.pivotY = 24;
    bmp2.pivotX = 11;
    bmp2.pivotY = 24;
    _broken.addChild(bmp1);
    _broken.addChild(bmp2);
    _broken.visible = false;

    /// manual adjustment.
    _broken.pivotX = bmp2.pivotX - 3;
    _broken.pivotY = -3;
  }

  _handleDown(e) {
    if (!_selected) return;
    stage.onMouseUp.addOnce(_handleUp);
    _star.tween(duration: .24, scale: .86, overwrite: 0);
  }

  _handleUp(e) {
    if (!_selected) return;
    _star.tween(duration: .5, scale: 1, overwrite: 0, ease: GEase.easeOutQuint);
  }

  bool _hovering = false;
  bool _selected = false;

  void selectState(bool flag) {
    if (_selected == flag) return;
    _selected = flag;
    if (!_selected) {
      /// remove star
      var dly = 0.0;
      _star.visible = false;

      final _color = kUnselectedSColor.withAlpha(0);

      _broken.setProps(
        y: 0,
        alpha: 1,
        visible: true,
        colorize: _color,
      );
      var p1 = _broken.children[0];
      var p2 = _broken.children[1];
      p1.setProps(rotation: 0, y: 0);
      p2.setProps(rotation: 0, y: 0);

      p1.tween(
        duration: .25,
        rotation: -.23,
        y: -2,
        ease: GEase.easeOut,
      );
      p2.tween(
        duration: .8,
        delay: .1,
        rotation: .4,
        y: 8,
        ease: GEase.easeOutQuad,
      );

      _broken.tween(
        duration: .3,
        delay: .1,
        colorize: kUnselectedSColor,
        overwrite: 0,
      );

      var blur = GBlurFilter(0, 0);
      _broken.filters = [blur];
      var a = 0.0.twn;
      a.tween(8, duration: .5, delay: .16, onUpdate: () {
        blur.blurY = blur.blurX = a.value;
      });

      _broken.tween(
        duration: .6,
        overwrite: 0,
        y: 50,
        delay: dly,
        // rotation: rot,
        alpha: 0,
        ease: GEase.easeInCubic,
        onComplete: () {
          _broken.visible = false;
          _star.visible = false;
        },
      );
      _dot.tween(
        duration: .4,
        scale: 1,
        delay: .1,
        colorize: kUnselectedSColor,
      );
    } else {
      GTween.killTweensOf(_broken);
      _broken.visible = false;
      _star.setProps(y: 0, rotation: 0, scale: 0, visible: true);
      _dot.tween(duration: .6, scale: 0);
      _star.tween(
        duration: .5,
        delay: .1,
        scale: 1,
        alpha: 1,
        ease: GEase.easeOutBack,
        // ease: GEase.elasticOut,
      );
    }
  }

  void hoverState(bool flag) {
    if (_hovering == flag) return;
    _hovering = flag;
    if (_selected) {
    } else {
      if (_hovering) {
        _dot.tween(
          duration: .35,
          scale: 1.5,
          colorize: kStarColor,
        );
      } else {
        _dot.tween(
          duration: .5,
          scale: 1,
          colorize: kUnselectedSColor,
        );
      }
    }
  }
}
