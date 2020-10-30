import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graphx/gameutils.dart';
import 'package:graphx/graphx/core/graphx.dart';
import 'package:graphx/graphx/render/filters/color_filter.dart';
import 'package:graphx/graphx/render/graphics.dart';
import 'package:graphx/graphx/render/movie_clip.dart';
import 'package:graphx/graphx/render/particles/simple_particle_system.dart';
import 'package:graphx/graphx/textures/base_texture.dart';
import 'package:graphx/graphx/textures/gx_texture_utils.dart';
import 'package:graphx/graphx/utils/math_utils.dart';
import 'package:graphx/graphx/utils/texture_utils.dart';

class DemoParticlesMain extends RootScene {
  @override
  void init() {
    owner.core.config.useKeyboard = true;
    owner.core.config.usePointer = true;
  }

  @override
  void ready() {
    super.ready();
    owner.core.resumeTicker();
    owner.needsRepaint = true;

    // stage.color = Colors.green.value;
    // createTextures();
    // initUI();
    testParticles();
  }

  Future<void> testParticles() async {
    // var green_tx =
    //     await TextureUtils.createRect(color: Colors.green.value, w: 6, h: 6);

    TextureUtils.resolution = 3;
    var part_white =
        await TextureUtils.createCircle(color: Colors.white.value, radius: 4);
    stage.color = Colors.black.value;
    var p_tx =
        await AssetLoader.loadImageTexture('assets/game/flare/sparkle.png');

    var bmp = Bitmap(p_tx);
    addChild(bmp).setPosition(100, 100);

    var particles = SimpleParticleSystem();
    particles.useWorldSpace = true;
    particles.setPosition(stage.stageWidth / 2, stage.stageHeight / 2);
    particles.scale = .4;
//    particles.texture = p_tx;
    particles.texture = part_white;
    particles.setup();
    addChild(particles);
    particles.init();

    particles.emission = 2;
    particles.emissionTime = 1;
    particles.energy = 2;
    particles.emit = true;

    particles.initialColor = Colors.purpleAccent.value;
    particles.useAlphaOnColorFilter = false;
    particles.blendMode = BlendMode.screen;

    var g = Graphics();
    g.beginFill(0xff00ff, 1);
    g.drawStar(0, 0, 5, 10);
    g.endFill();
    particles.drawCallback = (canvas, paint) {
      g.paintWithFill(canvas, paint);
    };
//    particles.particleBlendMode = BlendMode.dstOver;
//    particles.particleBlendMode = BlendMode.src;
//    particles.particleBlendMode = BlendMode.srcATop;
//    particles.nativePaint.blendMode = BlendMode.screen;
    particles.dispersionAngleVariance = deg2rad(340);
//    particles.dispersionAngleVariance = deg2rad(150);
//    particles.dispersionAngle = deg2rad(20);
    particles.initialVelocity = 20;
    particles.initialVelocityVariance = 40;
    particles.initialAngularVelocity = .001;
//    particles.initialAngularVelocityVariance = .2;
    particles.initialAngleVariance = 4;
    particles.initialScaleVariance = 3;
    particles.endAlpha = 0;
//    particles.endColor = 0x550000;
    particles.endColor = Colors.cyan.value;
    particles.initialScale = .5;
    particles.endScale = 1;
    particles.endScaleVariance = .4;

//    stage.onEnterFrame.add(() {
////      particles.rotation += .1;
////      particles.setPosition(mouseX, mouseY);
//    });
    // particles.useWorldSpace = true;
    // particles.node.setPosition(200, 100);
  }

  // GxTexture rectTexture;
  void createTextures() async {
    var explosionGTexture =
        await AssetLoader.loadImageTexture('assets/game/exp2.jpg');

    var explosionAtlas = TextureUtils.getRectAtlasFromTexture(
      explosionGTexture,
      64,
      scale: 1,
    );
    var red_tx = await TextureUtils.createRect(color: Colors.redAccent.value);
    var green_tx = await TextureUtils.createRect(color: Colors.green.value);
    var purple_tx =
        await TextureUtils.createRect(color: Colors.deepPurple.value);

    var movies = List.generate(400, (index) {
      var mc = MovieClip();
      addChild(mc);
      mc.setFrameTextures(explosionAtlas);
      // mc.gotoFrame(1);
      mc.repeatable = true;
      // mc.reversed = true;
      mc.speed = 1 / GameUtils.rndRangeInt(20, 30);
      final frame = GameUtils.rndRangeInt(0, mc.frameCount - 1);
      mc.gotoAndPlay(frame);
      mc.nativePaint.blendMode = BlendMode.screen;
      // mc.nativePaint.colorFilter = ColorFilters.sepia;
      // mc.nativePaint.colorFilter =
      //     ColorFilter.mode(Colors.redAccent, BlendMode.hue);
      // mc.nativePaint.blendMode = BlendMode.lighten;
      // mc.setPosition(50, 50);
      mc.setPosition(
        GameUtils.rndRange(100, stage.stageWidth - 100),
        GameUtils.rndRange(100, stage.stageHeight - 100),
      );
      mc.alignPivot();
      // print(mc.width);
      // mc.x = stage.stageWidth - mc.width;
      // mc.y = stage.stageHeight - mc.height;
      // mc.setPosition(0, 0);
      // print("Stage size: ${stage.stageWidth}x${stage.stageHeight}");
      return mc;
    });
    // stage.color = Colors.red.value;
    stage.color = Colors.black.value;

    var baseUrl = 'assets/game/flare';
    TextureUtils.resolution = 2;
    var aura_tx = await AssetLoader.loadImageTexture('$baseUrl/aura.png');
    var nova_tx = await AssetLoader.loadImageTexture('$baseUrl/nova.png');
    var sparkle_tx = await AssetLoader.loadImageTexture('$baseUrl/sparkle.png');

//    var sp = Bitmap(sparkle_tx);
//    sp.alignPivot();
//    sp.nativePaint.blendMode = BlendMode.screen;
//    sp.setPosition(100, 150);
//    sp.scale = .5;
//    addChild(sp);

    var a = Shape();
    addChild(a);
    a.graphics.beginFill(0xff0000);
    a.graphics.drawRect(0, 0, 20, 20);
    a.graphics.endFill();
    a.x = 686 - 24.0;

    var nova = Bitmap(nova_tx);
    nova.alignPivot();
    nova.setPosition(200, 200);

    var aura = Bitmap(aura_tx);
    // addChild(aura);
    aura.alignPivot();
    aura.setPosition(200, 200);

    // addChild(nova);
    nova.scale = 2;
    nova.alpha = .4;
    // aura.nativePaint.blendMode = BlendMode.multiply;
    aura.nativePaint.colorFilter =
        ColorFilter.mode(Colors.purpleAccent.withOpacity(.25), BlendMode.color);
    nova.nativePaint.blendMode = BlendMode.lighten;
    nova.nativePaint.colorFilter = ColorFilters.sepia;
    // nova.nativePaint.colorFilter =
    //     ColorFilter.mode(Colors.amber.withOpacity(.5), BlendMode.screen);
    double novaCounter = 0.0;
    ScenePainter.current.onUpdate.add((double t) {
      novaCounter += .03;
      movies.forEach((mc) {
        mc.scale = sin(-novaCounter);
        // mc.alpha = .2 + (.5 + sin(novaCounter) / 2);
        mc.update(t);
      });
      // // mc.update(t);
      // novaCounter += .07;
      // nova.alpha = .3 + (.5 + sin(novaCounter) / 2) * .5;
      // nova.skewX = sin(novaCounter / 2) * .12;
      // nova.skewY = sin(-novaCounter / 2) * .12;
      // nova.rotation -= .01;
      // aura.rotation += .01;
      //
      // aura.scale = .4 + (.5 + sin(novaCounter / 2) / 2) * .4;
    });
  }

  void initUI() {
//    print(ScenePainter.current);
    final c = ScenePainter.current;
    var sh = Shape();
    sh.graphics.beginFill(0xff0000);
    sh.graphics.drawCircle(0, 0, 20);
    sh.graphics.endFill();
    addChild(sh);
    c.onUpdate.add((double t) {
      sh.x += .10;
      sh.y += .10;
      // print('ticking');
    });
//    stage.onEnterFrame.add(() {
////      print(ScenePainter.current);
//    });
  }
}
