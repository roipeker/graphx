import 'package:flutter/material.dart';
import 'package:graphx/demos/svg_demo/svg_assets.dart';
import 'package:graphx/demos/svg_demo/svg_utils.dart';
import 'package:graphx/graphx/graphx.dart';
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
    ufo.tint = Colors.red;
//    ufo.blendMode = BlendMode.srcIn;
    ufo.usePaint = true;
    var sun = _add(sunData, stage.stageWidth - 100, 200);
    sun.alignPivot();
    sun.scale = 2;
    stage.onEnterFrame.add(() {
      sun.rotation += .02;
    });
    ship1.x += 100;
    ship1.y += 100;
  }
}
