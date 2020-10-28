import 'package:flutter/material.dart';
import 'package:graphx/demos/svg_demo/svg_assets.dart';
import 'package:graphx/demos/svg_demo/svg_utils.dart';
import 'package:graphx/graphx/core/graphx.dart';
import 'package:graphx/graphx/render/svg_shape.dart';

class TestSVGMain extends RootScene {
  @override
  void init() {
    owner.core.config.useKeyboard = true;
  }

  @override
  void ready() {
    super.ready();
    owner.core.resumeTicker();
    owner.needsRepaint = true;
    loadSvgs();
  }

  Future<void> loadSvgs() async {
    _loadSpaceStuffs();
  }

  Future<void> _loadSpaceStuffs() async {
    var ship1Data = await SvgUtils.svgDataFromString(SvgAssetsSpace.ship1);
    var ship2Data = await SvgUtils.svgDataFromString(SvgAssetsSpace.ship2);
    var sunData = await SvgUtils.svgDataFromString(SvgAssetsSpace.sun);
    var ufoData = await SvgUtils.svgDataFromString(SvgAssetsSpace.ufo);

    SvgShape _add(SvgData data, [double x = 100, double y = 100]) {
      var obj = SvgShape(data);
//      obj.$debugBounds = true;
      obj.setPosition(x, y);
      addChild(obj);
      return obj;
    }

    var ship1 = _add(ship1Data);
    var ship2 = _add(ship2Data, 180);
    var ufo = _add(ufoData, 80, 300);
    var ufoImage = await ufo.createImage();
//    ship2.tint = Colors.black;
//    ufo.blendMode = BlendMode.srcIn;
//    ship2.usePaint = true;
//    stage.color = Colors.blue.value;

    var sun = _add(sunData, stage.stageWidth - 100, 200);
    sun.alignPivot();
    sun.scale = 2;
    stage.onEnterFrame.add(() {
      sun.rotation += .02;
    });
//    ufo.transformationMatrix = sun.transformationMatrix;
//    ufo.name = 'ufo';
//    sun.name = 'sun';
//    sun.mask = ufo;

    var aa = Shape();
    addChild(aa);
    aa.graphics
        .beginFill(0x0, 1)
        .drawCircle(10, 10, 10)
//        .drawCircle(14, 10, 12)
        .endFill();
    sun.mask = ship1;
//    sun.mask = aa;

//    addChild(ufo);
//    ufo.removeFromParent();
//    sun.removeFromParent();

    return;
    BlendMode ufoBlendMode1 = BlendMode.values.first;
    BlendMode ufoBlendMode2 = BlendMode.values.first;
    final blendModeMaxCount = BlendMode.values.length - 1;
    var isBlend1 = false;

    int blendModeCount = 0;
    void moveBlendMode(int dir) {
      blendModeCount += dir;
      if (blendModeCount < 0)
        blendModeCount = blendModeMaxCount;
      else if (blendModeCount > blendModeMaxCount) blendModeCount = 0;
      if (isBlend1) {
        ufoBlendMode1 = BlendMode.values[blendModeCount];
      } else {
        ufoBlendMode2 = BlendMode.values[blendModeCount];
      }
      print(
          '$blendModeCount -- $ufoBlendMode1 / $ufoBlendMode2 /// ${isBlend1 ? 1 : 2}'); // dtsATop, dstIn
    }

    ufoBlendMode1 = BlendMode.dstIn;
    ufoBlendMode2 = BlendMode.dstIn;
    stage.keyboard.onUp.add((e) {
      if (e.arrowLeft) {
        moveBlendMode(-1);
      } else if (e.arrowRight) {
        moveBlendMode(1);
      } else if (e.arrowDown) {
        print("DPW!");
        isBlend1 = !isBlend1;
        print("Current blend is: ${isBlend1 ? 1 : 2}");
      }
    });

//    ufo.onPrePaint.add(() {
//      var myPaint = Paint();
//      myPaint.blendMode = ufoBlendMode1;
////      myPaint.invertColors = true;
//      myPaint.color = Colors.white30;
//      myPaint.colorFilter = ColorFilter.mode(Colors.white30, ufoBlendMode2);
//      $canvas.saveLayer(ufo.bounds.toNative(), myPaint);
//    });
//    ufo.onPostPaint.add(() {
//      $canvas.restore();
//    });
//    sun.removeFromParent();
    stage.color = Colors.blue.value;
    var spr = Sprite();
    spr.onPrePaint.add(() {
      var myPaint = Paint();
//      myPaint.blendMode = ufoBlendMode1;
//      myPaint.invertColors = true;
//      myPaint.color = Colors.white30;
//      myPaint.colorFilter = ColorFilter.mode(Colors.red, ufoBlendMode2);
      $canvas.save();
      $canvas.translate(sun.x, sun.y);
      $canvas.scale(2, 2);

      $canvas.saveLayer(null, myPaint);
      $canvas.drawPicture(sun.data.picture);

      var bmpPaint = Paint();
      bmpPaint.blendMode = ufoBlendMode1;
      bmpPaint.color = Colors.red.withOpacity(1);
//      $canvas.saveLayer(null, bmpPaint);
//      $canvas.drawPicture(ufo.data.picture);
      $canvas.drawImage(ufoImage, Offset.zero, bmpPaint);

//      $canvas.restore();
      $canvas.restore();
      $canvas.restore();
    });
    addChild(spr);
  }
}
