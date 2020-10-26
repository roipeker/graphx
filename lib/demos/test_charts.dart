import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphx/graphx/display/bitmap.dart';
import 'package:graphx/graphx/display/shape.dart';
import 'package:graphx/graphx/display/sprite.dart';
import 'package:graphx/graphx/display/static_text.dart';
import 'package:graphx/graphx/events/pointer_data.dart';
import 'package:graphx/graphx/geom/gxpoint.dart';
import 'package:graphx/graphx/render/gx_icon.dart';
import 'package:graphx/graphx/scene_painter.dart';
import 'package:graphx/graphx/textures/base_texture.dart';

class GraphChartDemo extends RootScene {
  @override
  void init() {
    owner.needsRepaint = true;
    owner.core.config.useTicker = true;
    owner.core.config.usePointer = true;
    owner.core.config.useKeyboard = true;
    owner.core.config.painterWillChange = true;
  }

  GxTexture bd;
  Picture pic;

  @override
  void ready() {
    super.ready();

    /// starts the Ticker, required for onEnterFrame()
    owner.core.resumeTicker();

    /// clips the stage area.
    stage.maskBounds = true;

    var icono = GxIcon(Icons.add_location_alt, Colors.white.value, 48.0);
    icono.setShadow(Shadow(color: Colors.black38, blurRadius: 4));
//    addChild(icono);
//    icono.setPosition(100, 100);
//    icono.alignPivot();

//    return;
    var iconContainer = new Sprite();

    iconContainer.graphics.beginFill(0xff00ff, .4);
    iconContainer.graphics.drawRect(0, 0, icono.width, icono.height);
    iconContainer.graphics.endFill();

    iconContainer.addChild(icono);
    addChild(iconContainer);

    var spr = Sprite();
    addChild(spr);
    spr.onPostPaint.add(() {
//      $canvas.drawCircle(Offset(20, 20), 40, Paint()..color = Colors.redAccent);

//      if (pic != null) {
//        $canvas.save();
//        $canvas.translate(100.0, 100.0);
//        $canvas.drawPicture(pic);
//        $canvas.restore();
//      }
//
//      if (bd != null) {
//        $canvas.drawImage(
//          bd.source,
//          Offset(30, 30),
//          Paint()..color = Colors.blueAccent,
//        );
//      }
    });
    void createIconTexture() async {
      bd = await iconContainer.createImageTexture(true, 2);
      var iconBmp = Bitmap(bd);
      addChild(iconBmp);
      print("icon bmp bounds: ${iconBmp.bounds}");
      iconBmp.x = 100;
      iconBmp.y = 100;
      iconBmp.alignPivot(Alignment.bottomCenter);
      iconBmp.rotation = .3;
      double cnt = 0;
      stage.onEnterFrame.add(() {
        cnt += .1;
        iconBmp.rotation += .03;
        iconBmp.scaleX = (sin(cnt) * 1.2);
        iconBmp.scaleY = (-sin(cnt / 4) * 1.2);
      });
    }

    createIconTexture();

    return;

    icono.onDown.add((e) => print("Mouse down::: $e"));

//    stage.pointer.onHover.add((e) {
//      if (icono.hitTouch(icono.globalToLocal(e.stagePosition))) {
//        icono.color = 0xff0000;
//      } else {
//        icono.color = 0xffffff;
//      }
//    });
//
//    stage.pointer.onDown.add((e) {
//      icono.icon = Icons.add_circle_outline;
//    });

//    icono.scaleX = 2;
//    icono.skewX = .2;

    var box = Shape();
    addChild(box);

    /// drawing api to make a red square, 30x30 points.
    box.graphics.beginFill(0xff0000).drawRect(0, 0, 30, 30).endFill();

    /// position the box at x=10, y=100.
    box.setPosition(10, 100);
    double count = 0;
    stage.onEnterFrame.add(() {
      count += .005;
//      icono.skewX = (sin(-count * 3)) * .3;
      icono.rotation = (sin(-count * 3)) * .3;
      icono.scale = .4 + (.5 + sin(count) / 2) * .8;

      /// every frame (~16ms), increase by 2 points the position
      /// of the box in the X axis, would be like doing `Positioned(left+:2)`
      /// if it "exists"
//      box.x += 2;

      /// if we go beyond our stage bounds, move the box back to the start...
      if (box.x > stage.stageWidth) {
        box.x = -box.width;
      }
    });

//    var btn = MyButton();
//    addChild(btn);
//
//    owner.core.isTicking
//    owner.core.resumeTicker()
//    owner.core.pauseTicker()
//
//    btn.setPosition(
//      stage.stageWidth / 2,
//      stage.stageHeight / 2,
//    );
//
////    text.rotation = -.2;
//
//    final myPoints = [
//      GxPoint(0, 0),
//      GxPoint(100, 100),
//      GxPoint(200, 0),
//      GxPoint(100, -100),
//      GxPoint(0, 0),
//    ];
//
//    final offPoints = myPoints.map((e) => e.toNative()).toList();
//
////    stage.onEnterFrame.add(() {
//////      myPoints[0].x += .2 / timeDilation;
//////      offPoints[0] = myPoints[0].toNative();
////      myTitle.rotation += .1 / timeDilation;
////    });
//
//    stage.pointer.onDown.add((e) {
//      owner.needsRepaint = !owner.needsRepaint;
//      owner.core.isTicking
//          ? owner.core.pauseTicker()
//          : owner.core.resumeTicker();
//    });
//
//    myTitle.onPrePaint.add(() {
//      $canvas.drawPoints(
//          PointMode.points,
//          offPoints,
//          Paint()
//            ..color = Colors.blue
//            ..strokeCap = StrokeCap.round
//            ..isAntiAlias = true
//            ..strokeWidth = 4);
//    });
//
//    var shape = Shape();
//    addChild(shape);
//    shape.graphics.beginFill(0x00ff33, .5);
////    shape.graphics.drawRect(-10, -10, 30, 30);
//    shape.graphics.drawRect(-10, -10, 30, 30);
//    shape.graphics.drawCircle(30, 30, 2);
//    shape.graphics.endFill();
//
////    shape.scaleX = 1.9;
////    shape.scaleY = 1.9;
//    shape.rotation = .25;
////    shape.skewX = .125;
//
////    var shapeRect = shape.getBounds(this);
//    void drawBounds(DisplayObject obj) {
//      graphics.lineStyle(0, Colors.purple.value, 1)
//        ..drawGxRect(obj.getBounds(this).inflate(-2, -6))
//        ..endFill();
//    }
//
//    drawBounds(shape);
////    drawBounds(text);
//    stage.pointer.onDown.add((e) {
////      print(shape.getBounds(this));
////      print(e);
//    });
  }
}

class MyButton extends Sprite {
  static int pressedColor = 0x005A9E;
  static int releasedColor = 0x0078D4;
  int _currentColor = releasedColor;

  /// how many times we clicked the button.
  int _pressCount = 0;

  double _w = 120, _h = 32;
  StaticText _stext;

  MyButton() {
    draw();
    onAddedToStage.add(_onAddedToStage);
  }

  bool _isPointTouching(GxPoint p) => hitTouch(globalToLocal(p));

  void _onAddedToStage() {
    onRemovedFromStage.addOnce(() {
      /// ubsubscribe when we remove from stage.
      stage.pointer.onDown.remove(_onMouseDown);
    });
    stage.pointer.onDown.add(_onMouseDown);
    _stext = StaticText(
      text: 'Hello GraphX',
      paragraphStyle: ParagraphStyle(textAlign: TextAlign.center),
      textStyle: StaticText.getStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w300,
      ),
      width: _w,
    );
    _stext.alignPivot();
    alignPivot();
    _stext.setPosition(_w / 2, _h / 2 - 1);
    addChild(_stext);
  }

  void draw() {
    if (inStage) stage.scene.requestRepaint();

    /// we draw a "focus" border around the button.
    final borderOffset = 2.0;
    graphics.clear()
      ..lineStyle(2, 0x0, 1, true, StrokeCap.square, StrokeJoin.bevel)
      ..drawRect(
        -borderOffset,
        -borderOffset,
        _w + borderOffset * 2,
        _h + borderOffset * 2,
      )
      ..endFill()

      /// we draw the fill of the button with the current color in a
      /// roundRect with "border radius" 2
      ..beginFill(_currentColor)
      ..drawRoundRect(0, 0, _w, _h, 2)
      ..endFill();
  }

  void _onMouseDown(PointerEventData e) {
    if (_isPointTouching(e.stagePosition)) {
      /// register for 1 time callback each time we press.
      stage.pointer.onUp.addOnce((e) => _pressing(false));
      _pressing(true);
    }
  }

  void _pressing(bool flag) {
    _currentColor = flag ? pressedColor : releasedColor;
    _stext.scale = flag ? .95 : 1;
    draw();
    if (!flag) {
      ++_pressCount;
      print("You clicked the button $_pressCount times");
      if (_pressCount >= 5) {
        /// same as `parent.removeChild(this);`
        removeFromParent(true);
        print(
            "$runtimeType instance has been removed from rendering and disposed.");
      }
    }
  }
}
