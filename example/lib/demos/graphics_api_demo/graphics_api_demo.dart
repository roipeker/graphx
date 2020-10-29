import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'demo_triangles.dart';


class GraphicsApiDemo extends RootScene {
  @override
  void init() {
    owner.core.config.usePointer = true;
    owner.core.config.useTicker = true;
    owner.core.resumeTicker();
  }

  @override
  void ready() {
    super.ready();

    var demo = DemoTriangles();
    addChild(demo);
//    someTest();
  }

  void someTest() {
    //    graphics.beginFill(0x0);
//    graphics.drawGxRect(stage.getStageBounds(this));
//    graphics.endFill();
//    alignPivot();
//    setPosition(stage.stageWidth / 2, stage.stageHeight / 2);
//    rotation = .8;
//    print(stage.stageWidth);
//    print(bounds);

//    var bg = CurvedBg();
//    addChild(bg);
//    bg.alignPivot();
    return;

    var spiral = Shape();
    var spiralDots = Shape();
    addChild(spiral);
    addChild(spiralDots);

    spiral.graphics.lineStyle(2, Colors.purple.value);
    spiral.name = 'spiralLines';

    spiralDots.graphics.lineStyle(0, 0x0, .75);

    double radius = 0, angle = 0;
    final angleInc = MathUtils.pi2 / 50;
    for (var i = 0; i < 200; ++i) {
      radius += .5;
      angle += angleInc;
      var x = radius * cos(angle);
      var y = radius * sin(angle);
      spiralDots.graphics.drawCircle(x, y, 3);
      spiral.graphics.lineTo(x, y);
    }

//    drawCustomPath();

//    dotData.path = p;
//    myShape.graphics.pushData(dotData);

    return;

    var fill = Paint();
    fill.style = PaintingStyle.stroke;
    fill.strokeWidth = 12;
    fill.color = Colors.red;

    buildCircle() async {
      var sh = Shape();
      sh.graphics.beginFill(0x0);
      sh.graphics.drawCircle(0, 0, 2);
      sh.graphics.endFill();
      var img = await sh.createImageTexture();
      var img2 = Bitmap(img);
      addChild(img2);
      img2.setPosition(20, 20);
      final mtx = Matrix4.identity()..translate(10.0, 10.0);
      final shader = ImageShader(
        img.source,
        TileMode.repeated,
        TileMode.mirror,
        mtx.storage,
      );
      fill.colorFilter = ColorFilter.mode(Colors.red, BlendMode.srcIn);
      fill.shader = shader;
    }

    buildCircle();
//    fill.imageFilter=Imagefil

    spiral.onPostPaint.add(() {
      $canvas.drawCircle(Offset(100, 100), 40, fill);
    });

    return;
    spiral.graphics.lineStyle(1, 0x0, 1, true).drawEllipse(0, 0, 20, 30);
    spiral.graphics.lineStyle(1, 0xff00ff, 1, true).drawCircle(0, 0, 20);
    spiral.graphics
//        .beginFill(0x00ff00)
        .lineStyle(1, 0xff0000, 1, true)
        .drawRect(0, 0, 20, 20);

    final points = [
      GxPoint(0, 0),
      GxPoint(40, 60),
      GxPoint(80, 0),
    ];

    spiral.graphics.lineStyle(1, 0x00ff44).drawPoly(points);
    spiral.graphics
        .lineStyle(2, Colors.amber.value)
        .arc(40, 40, 20, deg2rad(12), deg2rad(48));
    spiral.graphics.clear();

    final g = spiral.graphics;

    /// cuadrado azul
    g.beginFill(Colors.blueAccent.value, 1).drawRect(0, 0, 50, 50).endFill();

    /// rectangulo rojo
    g.lineStyle(3, Colors.red.value, 2)
      ..drawRoundRect(20, 20, 120, 80, 12)
      ..endFill();

    /// comandos para hacer "agujeros" en los shapes anteriores.
    g.beginHole().drawCircle(35, 35, 9).drawRect(10, 10, 8, 8).endHole();
    g.endFill();

    var customData = GraphicsDrawingData();
    customData.path = Path()..addRect(Rect.fromLTRB(20, 20, 90, 90));

    customData.fill = Paint()..color = Colors.amber;
    customData.fill.maskFilter = MaskFilter.blur(BlurStyle.normal, 3.0);
    g.pushData(customData);

    var customData2 = customData.clone(true);
    customData2.fill.color = Colors.red;
    customData2.fill.maskFilter = null;
    g.pushData(customData2, true);

    g.beginHole();
    g.drawCircle(20, 20, 30);
    g.endHole(false);

    /// shift the current path in x/y.
    g.shiftPath(30, 30, false);

    var customData3 = customData2.clone(true, false);
    customData3.fill.blendMode = BlendMode.exclusion;
    g.pushData(customData3, true);

    g.shiftPath(30, 30, false);

    /// create a picture of the canvas.
    var picture = spiral.createPicture();

    /// transform the original.
    spiral.$debugBounds = true;
    spiral.alignPivot(Alignment.centerLeft);
    spiral.rotation = .4;

    /// create a new Shape and apply the picture into it.
    var myShape2 = Shape();
    myShape2.x = stage.stageWidth / 2;
    myShape2.y = stage.stageHeight / 2;
    addChild(myShape2);
    myShape2.graphics.drawPicture(picture);

//    g.shiftPath(30, 30, false);
//    g.drawCircle(100, 100, 20);

//    circ.graphics.lineStyle(2, Colors.blue.value).drawRect(0, 0, 20, 20);
//    circ.graphics.lineStyle(1, Colors.red.value).drawRect(0, 0, 20, 20);
//    circ.graphics.shiftPath(20, 20, true);
//    circ.graphics.shiftPath(20, 20, true);

//    final ctx = circ.graphics;
//    ctx.clear();
//    ctx.lineStyle(2, Colors.amber.value);
//    ctx.moveTo(20, 20); // Create a starting point
//    ctx.lineTo(100, 20); // Create a horizontal line
////    ctx.arcTo(150, 20, 180, 70, 50); // Create an arc
//    ctx.lineTo(150, 120);

//    circ.alignPivot(Alignment.topLeft);

//    circ.rotation = .8;
//    circ.$debugBounds = true;
//    circ.rotation = .9;
  }

  void drawCustomPath() {
    print("Child 0: ${getChildAt(0)}");
    getChildAt(1).visible = false;

//    getChildByName('spiralLines').scaleX = 1.2;
    var spiral = getChildByName('spiralLines');
    stage.scene.core.resumeTicker();
    stage.scene.needsRepaint = true;

    children.forEach((e) {
      e.visible = false;
    });

    double panelW = 268;
    double panelH = 80;
    double preloderThickness = 6;
    double preloaderProgress = 0; // 72% completed

    var panel = Sprite();
    addChild(panel);
    panel.graphics
        .beginFill(0x1E1F34)
        .drawRoundRect(0, 0, panelW, panelH, 14)
        .endFill();
    panel.alignPivot();

    /// draw preloader.
    var preloaderRatio = (panelH - preloderThickness - 12 * 2) / 2;

    var preloader = Sprite();
    panel.addChild(preloader);
    preloader.setPosition(panelH / 2, panelH / 2);

    var preloaderText = StaticText(
      text: '0%',
      paragraphStyle: ParagraphStyle(textAlign: TextAlign.center),
      textStyle: StaticText.getStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      width: preloaderRatio * 2,
    );
    preloader.addChild(preloaderText);
    preloaderText.alignPivot();

    var title = StaticText(
      text: 'Your Daily read',
      textStyle: StaticText.getStyle(
        color: Colors.white.withOpacity(.4),
        fontSize: 12,
        letterSpacing: .2,
        fontWeight: FontWeight.w300,
      ),
    );
    panel.addChild(title);
    title.scaleY = .94;
    title.x = preloader.x + preloaderRatio + preloader.pivotX + 15;
    title.y = preloader.y - 4;
    title.alignPivot(Alignment.bottomLeft);

    var hour = StaticText(
      text: '37:23',
      textStyle: StaticText.getStyle(
        color: Colors.white,
        fontSize: 20,
        letterSpacing: .3,
        fontWeight: FontWeight.w500,
      ),
    );
    panel.addChild(hour);
    hour.scaleX = 1.1;
    hour.x = title.x;
    hour.y = title.y + 4;
    hour.alignPivot(Alignment.topLeft);

//    print(deg2rad(2));
//    stage.onEnterFrame.add(() {
//      spiral.rotation += deg2rad(2);
//    });

    var ico = GxIcon(Icons.close, Colors.white.value, 14.0);
    ico.alpha = .5;
    ico.scale = 1.0;
    ico.alignPivot();
    panel.addChild(ico);
    ico.x = panelW - ico.size / 2 - 8;
    ico.y = ico.size / 2 + 8;
//    ico.onOut.add((e) {
//      ico.alpha = .4;
//    });
//    ico.onHover.add((e) {
//      ico.alpha = 1;
//    });
    ico.onUp.add((e) => ico.alpha = .5);
    ico.onDown.add((e) => ico.alpha = 1);

    void drawPreloader() {
      preloader.graphics.clear();
      preloader.graphics
          .lineStyle(preloderThickness, 0xffffff, .07)
          .drawCircle(0, 0, preloaderRatio)
          .endFill();
      preloader.graphics
          .lineStyle(preloderThickness, 0x5BB4C5, 1, true, StrokeCap.round)
          .arc(
            0,
            0,
            preloaderRatio,
            deg2rad(-90),
            deg2rad(360) * preloaderProgress,
          )
          .endFill();
      var preloaderTextValue = (preloaderProgress * 100).toStringAsFixed(0);
      preloaderText.text = preloaderTextValue + '%';
    }

//    drawPreloader();

    double cnt = 0;
    stage.onEnterFrame.add(() {
      cnt += .09;
      preloaderProgress += .005;
      if (preloaderProgress > 1) preloaderProgress = 0;
      drawPreloader();
      hour.scaleY = sin(cnt) * 1;
//      /panel.scaleY = sin(cnt) * 1.4;
//      panel.scaleY = sin(cnt) * 1.4;
    });
    return;
//    GxPath p = GxPath();
//    p.addCircle(0, 0, 10.0);
//    p.addRect(30, 0, 30, 30);
//    graphics.clear();
//    graphics.lineStyle(2, Colors.green.value);
//    var matrix = Pool.getMatrix();
//    matrix.scale(2.0, 1.0);
//    matrix.rotate(deg2rad(30));
//    graphics.drawPath(p.path, 0, 0, matrix);
//    p.path;
  }
}

class CurvedBg extends Sprite {
  double w = 250;
  double h = 160;

  CurvedBg() {
    init();
  }

  Shape _bg;

  void init() {
    _bg = Shape();
    addChild(_bg);

    testVertices();
    return;

    final g = _bg.graphics;
    g.beginFill(0x191B30);
//    g.drawRoundRect(0, 0, 250, 160, 14, 28);
    g.drawRoundRectComplex(0, 0, 250, 160, 14, 0, 0, 0);
    g.endFill();

    var smallRad = 10.0;
    var block = w / 3;
//    g.beginHole();
//    g.drawRect(block, 0, block, smallRad);
//    g.endHole();
//
//    g.beginFill(0x191B30);
//    g.drawCircle(block, smallRad, smallRad);
//    g.drawCircle(block + block, smallRad, smallRad);
//    g.endFill();
//
//    g.beginHole();
//    g.drawCircle(w / 2, smallRad, (block - smallRad * 2) / 2);
//    g.endHole(true);
//
//    g.beginFill(0xff0000);
//    g.drawCircle(w / 2, 12, 14);
//    g.endFill();
    g.lineStyle(0, 0xff0000);
    g.cubicCurveTo(0, 0, 40, 0, 60, 40);
//    g.cubicCurveTo(60, 40, 60 + 80.0, 0, 60, 40);
  }

  void testVertices() {
    var pos = <double>[
      0,
      0,
      80,
      80,
      0,
      160,
    ];
    var offs = <Offset>[];
    for (var i = 0; i < pos.length; i += 2) {
      offs.add(Offset(pos[i], pos[i + 1]));
    }
    var colors = <Color>[
      Colors.red,
      Colors.green,
      Colors.blue,
//      Color(0xff0000).withOpacity(1),
//      Color(0x00ff00).withOpacity(1),
//      Color(0x0000ff).withOpacity(1),
    ];
    var ver = Vertices(VertexMode.triangleStrip, offs, colors: colors);
    var myPaint = Paint();
    myPaint..color = Colors.redAccent;
    onPostPaint.add(() {
//      Vertices(mode, positions);
      $canvas.drawVertices(ver, BlendMode.src, myPaint);
    });
  }
}
