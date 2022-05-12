import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class UniversoFlutterScene extends GSprite {
  late GSprite logo, fLogo;
  late GShape planetCirc, ringBack, ringFront;
  GShape? fLogo1, fLogo2, fLogo3;

  @override
  void addedToStage() {
    stage!.color = Color(0xff212121);
    stage!.maskBounds = true;
    stage!.showBoundsRect = true;
    _buildLogo();
  }

  double get sw => stage!.stageWidth;

  double get sh => stage!.stageHeight;

  void _buildLogo() {
    _buildStars();

    logo = GSprite();
    addChild(logo);

    planetCirc = GShape();
    logo.addChild(planetCirc);
    planetCirc.graphics.beginFill(const Color(0xff235998)).drawCircle(0, 0, 415 / 2).endFill();

    ringBack = _buildRing(0);
    ringFront = _buildRing(2);

    var realH2 = 128.0;
    var realW = 28 + 100.0 * 2.0;
    ringBack.maskRect = GRect(-realW / 2, -realH2, realW, realH2 + 1.0);
    ringFront.maskRect = GRect(-realW / 2, 0, realW, realH2);

    /// build F logo
    fLogo = GSprite();
    fLogo.rotation = deg2rad(-45);
    // fLogo.$debugBounds = true;
    logo.addChild(fLogo);
    logo.setPosition(sw / 2, sh / 2);

    var fH = 37.0;
    fLogo1 = _buildPill(fLogo, 144, fH);
    fLogo2 = _buildPill(fLogo, 97, fH);
    fLogo3 = _buildPill(fLogo, 97, fH);
    fLogo2!.rotation = deg2rad(90);
    fLogo2!.y = fLogo3!.y = 54;
    fLogo.alignPivot();
    fLogo.y -= 54;

    testAnimation();
  }

  GShape _buildPill(GSprite doc, double tw, double th) {
    var pill = GShape();
    pill.graphics.beginFill(Colors.white).drawRoundRect(0, 0, tw, th, 13).endFill();
    doc.addChild(pill);
    pill.pivotX = pill.pivotY = th / 2;
    return pill;
  }

  GShape _buildRing(int childIndex) {
    var ring = GShape();
    ring.graphics.lineStyle(28, const Color(0xff6ECEF7)).drawCircle(0, 0, 100).endFill();
    ring.scaleX = 2.7;
    ring.scaleY = .6;
    ring.rotation = deg2rad(-45 / 2);
    // logo.addChild(ring);
    logo.addChildAt(ring, childIndex);
    return ring;
  }

  void _buildStars() {
    var bg = GShape();
    addChild(bg);
    final g = bg.graphics;
    var bgw = sw * 1.5;
    var bgh = sh * 1.5;
    g.beginFill(kColorBlack).drawRect(0, 0, bgw, bgh).endFill();
    List.generate(500, (index) {
      var tx = Math.randomRange(0, bgw);
      var ty = Math.randomRange(0, bgh);
      var tr = Math.randomRange(.4, 1.25);

      /// random blue shade...
      final blue = Math.randomRangeInt(125, 255);
      final color = Color.fromARGB(255, blue, blue, 255);
      g.beginFill(color.withOpacity(Math.randomRange(.25, 1)));
      g.drawCircle(tx, ty, tr);
      g.endFill();
    });

    void _twnBg() {
      bg.tween(
        duration: 8,
        // skewX: bg.skewX * -1,
        scale: bg.scale < 1 ? 1.2 : .95,
        rotation: '.4',
        skewX: Math.randomRange(-.1, .1),
        // skewY: GameUtils.rndRange(-.05, .05),
        ease: GEase.linear,
        onComplete: _twnBg,
      );
    }

    bg.alignPivot();
    bg.setPosition(sw / 2, sh / 2);
    _twnBg();
  }

  void testAnimation() {
    final rot = deg2rad(90);

    GTween.killTweensOf(fLogo1);
    GTween.killTweensOf(fLogo2);
    GTween.killTweensOf(fLogo3);

    logo.setProps(scale: .3, rotation: 1);
    planetCirc.setProps(scale: .3, alpha: .35);
    ringBack.setProps(scaleY: 2.7, alpha: .5);
    ringFront.setProps(scaleY: 2.7 / 2, alpha: .8);

    fLogo.setProps(rotation: 0);

    fLogo1!.setProps(scaleX: 0.5, scaleY: .7, alpha: 0, rotation: 1.9);
    fLogo2!.setProps(scaleX: 0.2, scaleY: .5, alpha: 0, rotation: 0);
    fLogo3!.setProps(scaleX: 0.6, scaleY: .2, alpha: 0, rotation: rot);

    logo.tween(duration: 1.6, scale: 1, rotation: 0, ease: GEase.easeInOutCirc);
    planetCirc.tween(duration: 2.5, alpha: 1, ease: GEase.easeInSine);
    planetCirc.tween(duration: 2, delay: 1, scale: 1, ease: GEase.elasticInOut);

    ringBack.tween(
      duration: 2,
      alpha: 1,
      delay: .8,
      scaleY: 2.7 / 2,
      ease: GEase.elasticOut,
    );

    ringFront.tween(
      duration: 1,
      alpha: 1,
    );

    fLogo1!.tween(
      duration: .4,
      delay: .4,
      scale: 1,
      alpha: 1,
      overwrite: 0,
    );
    fLogo1!.tween(
      duration: .8,
      delay: .6,
      rotation: 0,
      ease: GEase.easeOutBack,
      overwrite: 0,
    );

    fLogo2!.tween(
      delay: .9,
      duration: .4,
      scale: 1,
      alpha: 1,
      overwrite: 0,
    );
    fLogo2!.tween(
      delay: .9,
      duration: .7,
      rotation: rot,
      ease: GEase.easeInBack,
      overwrite: 0,
    );

    fLogo3!.tween(
      delay: 1,
      duration: .5,
      scale: 1,
      alpha: 1,
      overwrite: 0,
    );
    fLogo3!.tween(
      delay: 1,
      duration: .7,
      rotation: 0,
      ease: GEase.easeInBack,
      overwrite: 0,
    );

    fLogo.tween(
      delay: 1.2,
      duration: 1.4,
      rotation: deg2rad(-45),
      ease: GEase.easeInOutSine,
      overwrite: 0,
      onComplete: () {
        GTween.delayedCall(1, testAnimation);
      },
    );
  }
}
