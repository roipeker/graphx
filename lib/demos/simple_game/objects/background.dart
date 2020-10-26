import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphx/demos/simple_game/utils/game_mixins.dart';
import 'package:graphx/graphx/display/sprite.dart';
import 'package:graphx/graphx/graphx.dart';
import 'package:graphx/graphx/textures/base_texture.dart';
import 'package:graphx/graphx/utils/assets_loader.dart';

class GameBackground extends Sprite with GameObject {
  Bitmap bg;

  GameBackground() {
    onAddedToStage.add(init);
  }

  init() {
    _loadBitmap();
  }

  void _loadBitmap() async {
    var img = await AssetLoader.loadImage('assets/space.png');
    var texture = GxTexture(img);
    bg = Bitmap(texture);
    bg.alignPivot();
    bg.setPosition(stage.stageWidth / 2, stage.stageHeight / 2);
    addChildAt(bg, 0);
    bg.nativePaint.blendMode = BlendMode.lighten;
//    bg.nativePaint.color = Colors.white.withOpacity(.6);
//    bg.nativePaint.shader = ImageShader(
//      img,
//      TileMode.mirror,
//      TileMode.repeated,
//      null,
//    );
//    bg.onPostPaint.add((){
//      $
//    });
  }

  double bgCount = 0;

  void update() {
    if (bg == null) return;
    bgCount += .01;
    bg.scale = 1.3 + (0.5 + sin(bgCount) / 2) * .8;
//    bg.rotation = (0.5 + sin(bgCount / 2) / 2) * .8;

    double ref = world.ship.at;
    var ratio = ref / 7;
    var alpha = 0.3 + 0.3 * ratio;
    bg?.alpha = alpha;

    bg?.rotation = -world.ship.rotation / 2;
  }
}
