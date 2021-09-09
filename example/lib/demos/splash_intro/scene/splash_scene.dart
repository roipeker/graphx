/// copyright roipeker 2020
///
/// web demo:
/// https://roi-graphx-splash.surge.sh
///
/// source code (gists):
/// https://gist.github.com/roipeker/37374272d15539aa60c2bdc39001a035
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'logo_drawer.dart';
import 'svg_assets.dart';

abstract class DemoEvents {
  static const run = 'runDemo';
  static const reset = 'resetDemo';
}

class SplashScene extends GSprite {
  GSprite? logoContainer;
  late GShape splashCircle;
  late LogoDrawer graphxLogo, byLogo, roipekerLogo, flutterLogo;

  @override
  void addedToStage() {
    visible = false;
    stage!.onResized.add(_handleStageResize);
    mps.on(DemoEvents.reset, _showDemo);
    loadSvg();
  }

  void _handleStageResize() {
    /// keep the logo centered.
    logoContainer?.x = stage!.stageWidth / 2;
    logoContainer?.y = stage!.stageHeight / 2;
  }

  void _showDemo() {
    mps.emit1(DemoEvents.run, true);

    splashCircle.graphics.clear();
    splashCircle.graphics.beginFill(Colors.redAccent);
    splashCircle.graphics.drawCircle(0, 0, stage!.stageWidth);
    splashCircle.graphics.endFill();
    splashCircle.scale = 0;
    stage!.color = kColorTransparent;
    stage!.addChild(splashCircle);
    splashCircle.setPosition(stage!.stageWidth / 2, stage!.stageHeight / 2);

    splashCircle.tween(
      duration: 1,
      ease: GEase.easeInOutExpo,
      scale: 1,
      overwrite: 0,
      onComplete: () {
        splashCircle.graphics.clear();
        _runDemo();
      },
    );
  }

  void loadSvg() async {
    splashCircle = GShape();

    logoContainer = GSprite();
    addChild(logoContainer!);

    graphxLogo = await buildLogo(graphxSvgString);
    byLogo = await buildLogo(bySvgString);
    roipekerLogo = await buildLogo(roipekerSvgString);
    flutterLogo = await buildLogo(flutterSvgString);

    GTween.timeScale = 1.0;

    graphxLogo.drawFill(Colors.white);
    byLogo.drawFill(Colors.white);
    roipekerLogo.drawFill(Colors.white);

    roipekerLogo.alignPivot(Alignment.bottomRight);
    byLogo.alignPivot(Alignment.bottomRight);
    // flutterLogo.drawFill(Colors.blue);
    // GTween.delayedCall(1, _runDemo);
    // _runDemo();
  }

  void _resetObjects() {
    /// position elements.
    var ty = graphxLogo.height;

    /// flutter logo next to "graphx"
    flutterLogo.alignPivot(Alignment.bottomRight);
    flutterLogo.x = graphxLogo.x - 8;
    flutterLogo.y = ty;

    /// bottom elements are bottom aligned, so add that value to `ty`
    ty += roipekerLogo.pivotY + 10;

    roipekerLogo.scale = 1;
    roipekerLogo.y = ty;
    roipekerLogo.x = graphxLogo.width;

    byLogo.y = ty - 2;
    byLogo.x = roipekerLogo.x - roipekerLogo.width - 8;
    byLogo.line.y = 0;
    // byLogo.line.alpha = 1;

    graphxLogo.drawPercent(0);
    byLogo.drawPercent(0);
    roipekerLogo.drawPercent(0);
    flutterLogo.drawPercent(0);

    graphxLogo.fill.visible = false;
    byLogo.fill.visible = false;
    roipekerLogo.fill.visible = false;

    roipekerLogo.line.alpha = 1;

    graphxLogo.line.visible = true;
    byLogo.line.visible = true;
    roipekerLogo.line.visible = true;
    flutterLogo.line.visible = true;

    logoContainer!.alignPivot();
    logoContainer!.x = stage!.stageWidth / 2;
    logoContainer!.y = stage!.stageHeight / 2;
  }

  void _runDemo() {
    mps.emit1(DemoEvents.run, true);
    visible = true;
    stage!.color = Colors.redAccent;
    _resetObjects();
    var t1 = 0.0.twn;
    var t2 = 0.0.twn;
    var t3 = 0.0.twn;
    var t4 = 0.1.twn;

    /// increment the delay to simulate a global timeline.
    var dly = 0.0;

    t4.tween(
      1.0,
      duration: 1.8,
      delay: dly,
      overwrite: 0,
      ease: GEase.easeInOutCirc,
      onUpdate: () => flutterLogo.drawPercent(t4.value),
    );
    flutterLogo.scaleX -= 1;
    flutterLogo.tween(
      duration: 1,
      overwrite: 0,
      scaleX: 1,
      delay: .2,
      ease: GEase.easeOutBack,
    );

    t1.tween(
      1.0,
      duration: 2,
      ease: GEase.easeOut,
      overwrite: 0,
      onUpdate: () => graphxLogo.drawPercent(t1.value),
      onComplete: _showGraphxFill,
    );

    dly += 1.9;
    t2.tween(
      1.0,
      duration: 1,
      delay: dly,
      overwrite: 0,
      onUpdate: () => byLogo.drawPercent(t2.value),
      onComplete: _showByFill,
    );

    dly += .7;
    t3.tween(
      1.0,
      duration: 2,
      delay: dly,
      ease: GEase.easeInOutExpo,
      overwrite: 0,
      onUpdate: () => roipekerLogo.drawPercent(t3.value),
      onComplete: _showRoiFill,
    );
  }

  void _showByFill() {
    // byLogo.fill.y = -20;
    byLogo.line.tween(
      duration: .25,
      y: -20,
      ease: GEase.easeInCirc,
      onComplete: () => byLogo.line.alpha = .6,
      overwrite: 0,
    );
    // byLogo.fill.tween(
    byLogo.line.tween(
      duration: .4,
      delay: .25,
      ease: GEase.bounceOut,
      overwrite: 0,
      y: 0,
    );
  }

  void _showRoiFill() {
    roipekerLogo.fill.visible = true;
    roipekerLogo.fill.alpha = 0;
    roipekerLogo.line.tween(duration: .25, alpha: 0);
    roipekerLogo.fill.tween(duration: .7, alpha: 1);

    roipekerLogo.tween(
      duration: .7,
      scale: .75,
      delay: .25,
      ease: GEase.easeOutBack,
      overwrite: 0,
    );

    byLogo.tween(
      duration: .2,
      skewX: -.7,
      rotation: -.1,
      delay: .7,
      ease: GEase.easeOut,
      overwrite: 0,
    );

    var px = roipekerLogo.x - roipekerLogo.width * .75 - 8;
    byLogo.tween(
      duration: .8,
      x: px,
      delay: .8,
      ease: GEase.bounceOut,
      overwrite: 0,
    );
    byLogo.tween(
      duration: 2.2,
      skewX: 0,
      rotation: 0,
      delay: .8,
      ease: GEase.elasticOut,
      overwrite: 0,
    );
    GTween.delayedCall(2.5, _showGlobalMask);
  }

  void _showGlobalMask() {
    splashCircle.graphics.clear();
    splashCircle.graphics.beginFill(Colors.white);
    splashCircle.graphics.drawCircle(0, 0, stage!.stageWidth);
    splashCircle.graphics.endFill();
    stage!.addChild(splashCircle);
    splashCircle.scale = 0.1;
    splashCircle.setPosition(stage!.stageWidth / 2, stage!.stageHeight / 2);
    splashCircle.tween(
      duration: .45,
      scale: 1,
      // x: stage.stageWidth / 2,
      // y: stage.stageHeight / 2,
      ease: GEase.easeInCirc,
      onComplete: showFlutter,
      overwrite: 0,
    );
  }

  void showFlutter() {
    stage!.addChild(splashCircle);
    stage!.color = kColorTransparent;
    splashCircle.tween(
      duration: .4,
      scale: 0,
      // x: stage.stageWidth,
      // y: stage.stageHeight / 2,
      ease: GEase.easeOutQuint,
      onComplete: () {
        splashCircle.removeFromParent();
        mps.emit1(DemoEvents.run, false);
      },
      overwrite: 0,
    );
    visible = false;
  }

  void _showGraphxFill() {
    /// create a GShape to hide the transition between line and fill.
    var msk = GShape();
    msk.x = -5;
    msk.graphics
        .beginFill(Colors.white)
        .drawRect(0, -5, graphxLogo.width + 10, graphxLogo.height + 10)
        .endFill();
    msk.scaleX = 0;
    msk.tween(
      duration: .8,
      scaleX: 1,
      ease: GEase.easeInOutExpo,
      overwrite: 0,
    );
    msk.tween(
      duration: .8,
      delay: .8,
      scaleX: 0,
      ease: GEase.easeInOutExpo,
      overwrite: 0,
      onStart: () {
        /// change line to fill.
        graphxLogo.line.visible = false;
        graphxLogo.fill.visible = true;
        msk.pivotX = msk.width;
        msk.x += msk.pivotX;
      },
      onComplete: () => msk.removeFromParent(true),
    );
    graphxLogo.addChild(msk);
  }

  Future<LogoDrawer> buildLogo(String word) async {
    var logo = LogoDrawer();
    await logo.parseSvg(word);
    logoContainer!.addChild(logo);
    return logo;
  }
}
