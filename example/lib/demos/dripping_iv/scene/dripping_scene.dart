import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';
import 'svgs.dart';

class DrippingScene extends GSprite {
  late GSvgShape drop;
  double tubeW = 38, tubeH = 157, tubeOffset = 4.0;
  late GSprite tubeContainer;
  GShape? water, tubeMask;

  @override
  Future<void> addedToStage() async {
    stage!.color = Colors.red;
    var dropData = await SvgUtils.svgDataFromString(dropSvg);
    var tubeData = await SvgUtils.svgDataFromString(tubeSvgString);
    const waterColor = Colors.white;

    var tube = GSvgShape(tubeData);
    addChild(tube);
    tubeMask = GShape();
    tubeMask!.setPosition(13, 29);
    tubeMask!.graphics
        .beginFill(Colors.white.withOpacity(.2))
        .drawRoundRect(tubeOffset, tubeOffset, tubeW - tubeOffset * 2,
            tubeH - tubeOffset * 2, tubeW / 2)
        .endFill();
    addChild(tubeMask!);

    tubeContainer = GSprite();
    tubeContainer.setPosition(tubeMask!.x, tubeMask!.y);
    tubeContainer.mask = tubeMask;
    addChild(tubeContainer);

    drop = GSvgShape(dropData);
    drop.alpha = .75;
    drop.tint = waterColor;
    drop.x = 38 / 2;
    tubeContainer.addChild(drop);

    water = GShape();
    water!.graphics
        .beginFill(waterColor.withOpacity(.5))
        .drawRect(0, 0, tubeW, 30);
    water!.alignPivot(Alignment.bottomLeft);
    water!.y = tubeH;
    tubeContainer.addChild(water!);

    addParticles();
    // moveWater();
    resetDripping();

    /// This shouldnt be needed... if u wrap in a Sized widget.
    alignPivot();
    setPosition(stage!.stageWidth / 2, stage!.stageHeight / 2);
  }

  void resetDripping() {
    drop.y = tubeOffset;
    drop.alignPivot(Alignment.topCenter);
    drop.scale = 0;
    drip();
  }

  void moveWater() {
    double targetH = water!.height > 10 ? 5 : tubeH / 2;

    /// toggle water box height up and down...
    water!.tween(
        duration: 6,
        height: targetH,
        ease: GEase.linearToEaseOut,
        onComplete: moveWater);
  }

  void _dropDown() {
    drop.alignPivot(Alignment.bottomCenter);
    drop.y = tubeOffset + drop.pivotY;
  }

  void drip() {
    drop.scale = 0;
    drop.tween(duration: 2, scaleX: 1, ease: GEase.linearToEaseOut);
    drop.tween(
        duration: 2,
        scaleY: 1,
        ease: GEase.bounceOut,
        overwrite: 0,
        onComplete: _dropDown);
    drop.tween(
        duration: .6,
        delay: 2,
        onStart: () {},
        y: tubeH - 30,
        ease: GEase.easeInCirc,
        overwrite: 0);
    drop.tween(
        duration: .6,
        delay: 2.6,
        scaleX: 4,
        scaleY: .15,
        ease: GEase.easeOutExpo,
        overwrite: 0);
    drop.tween(
        duration: .5,
        delay: 2.6 + .6,
        scaleY: 0,
        ease: GEase.easeOut,
        overwrite: 0,
        onComplete: resetDripping);
  }

  /// experimental particle system.
  void addParticles() async {
    var particle =
        await GTextureUtils.createCircle(color: Colors.white, radius: 2);

    /// just play with all the properties.
    var particles = GSimpleParticleSystem();
    particles.texture = particle;
    particles.emission = 80;
    particles.emissionTime = .9;
    particles.emit = true;
    particles.energy = 1.2;
    // _particleSystem.burst=true;
    // _particleSystem.initialAngularVelocity=.004;
    particles.initialAngle = -Math.PI;
    particles.dispersionAngleVariance = Math.PI / 4;
    particles.dispersionAngle = -Math.PI / 1.5;
    particles.initialVelocity = 20;
    particles.initialVelocityVariance = 20;
    // _particleSystem.initialVelocity = 40;
    // _particleSystem.initialVelocityVariance = 80;
    // _particleSystem.particlePivotX = 50.0;
    // _particleSystem.particlePivotY = 10.0;

    // _particleSystem.dispersionXVariance = 200;
    // _particleSystem.dispersionYVariance = 200;
    // _particleSystem.initialAngleVariance = 3;
    // _particleSystem.initialScaleVariance = .2;
    particles.endAlpha = 0;
    // _particleSystem.endBlue = 1;
    // _particleSystem.endRed = .4;
    // _particleSystem.initialRed = .2;
    particles.initialAlpha = .4;
    particles.initialAlphaVariance = .6;
    particles.initialScale = .25;
    particles.initialScaleVariance = .53;
    particles.endScale = .13;
    particles.endScaleVariance = .23;
    particles.useWorldSpace = true;
    particles.dispersionXVariance = tubeW / 2;
    tubeContainer.addChild(particles);
    particles.x = tubeW / 2;
    particles.y = tubeH;
    // var isUp = false ;
    // tweenUP(){
    //   isUp=!isUp;
    //   particles.tween(duration: 1, y:isUp?'-80':'80', onComplete: tweenUP);
    // }
    // tweenUP();
  }
}
