import 'package:flutter/material.dart';
import 'package:graphx/graphx/display/shape.dart';
import 'package:graphx/graphx/display/sprite.dart';
import 'package:graphx/graphx/scene_painter.dart';
import 'package:graphx/graphx/utils/math_utils.dart';
import 'package:graphx/graphx/utils/pools.dart';

class Test2Scene extends RootScene {
  @override
  void init() {
    owner.core.config.useTicker = true;
    owner.core.config.usePointer = true;
    owner.needsRepaint = true;
    owner.core.config.painterIsComplex = false;
  }

  @override
  void ready() {
    super.ready();
    owner.core.resumeTicker();

    var bg = Shape();
    addChild(bg);
    bg.graphics
      ..beginFill(0x0, .12)
      ..drawRect(0, 0, stage.stageWidth, stage.stageHeight)
      ..endFill();
//    stage.color = 0xffff0000;

    var pink = createBox(1);
    addChild(pink);
    pink.setPosition(100, 100);
    pink.name = 'pink';

    var blue = createBox(5);
    addChild(blue);
    blue.setPosition(100, 20);
    blue.name = 'blue';

    var o1 = Shape();
    o1.graphics
      ..lineStyle(0, 0x0)
      ..drawCircle(0, 0, 2)
      ..endFill();

    var o2 = Shape();
    o2.graphics.copyFrom(o1.graphics);
    addChild(o1);
    addChild(o2);

//
//    pink.alignPivot();
//    pink.skewY = .4;
//    pink.skewX = .1;
//    pink.rotation = .6;
//    pink.scaleY = 1.9;
//    pink.scaleX = 1.2;
//
//    blue.transformationMatrix = pink.transformationMatrix;
//    blue.y += 120;
//
//    stage.pointer.onHover.add((e) {
//      var p = e.stagePosition;
//      blue.globalToLocal(p, p);
//      var a = blue.hitTest(p);
//      bool isHit = a != null;
//      if (isHit) {
//        blue.alpha = .5;
//      } else {
//        blue.alpha = 1;
//      }
//    });

    stage.pointer.onDown.add((e) {
      pink.height += 10;
      var p = e.stagePosition;
      pink.globalToLocal(p, p);
      var a = pink.hitTest(p);
      print(p);

//      print(pink.height);
//      var p = e.stagePosition;
//      blue.globalToLocal(p, p);
//      var a = blue.hitTest(p);
//      if (blue.parent != pink) {
//        blue.setPosition(0, 0);
////        blue.setPosition(40 / 2, 40 / 2);
//        pink.addChild(blue);
//      }
//      print(a);
    });
//    double cnt = 0.0;
//    stage.onEnterFrame.add(() {
//      pink.rotation += .04;
//      blue.rotation += .02;
//      cnt += .04;
//      o1.setPosition(pink.x, pink.y);
//      o2.setPosition(blue.x, blue.y);
//    });
    return;

//    var green = createBox(10);
//    addChild(green);
//    green.x = 120;
//    green.y = 120;
//    green.scaleX = -1.5;
//    green.rotation = deg2rad(20);
//    green.scaleY = -.2;

    pink.x = 50 + 100.0;
    pink.y = 50 + 140.0;
    pink.x += 10;
    pink.name = 'pink';
    pink.getChildAt(0).name = 'pink';
    pink.scaleX = 2;
    pink.scaleY = 1.2;
    pink.rotation = deg2rad(38);
    pink.pivotY = 20;

    var boundingbox = Shape();
    addChildAt(boundingbox, 0);
    boundingbox.name = 'boundingbox';

    removeChild(bg);
    var r = getBounds(this);
//    addChildAt(bg, 0);
    print(r);
    boundingbox.graphics.lineStyle(2, 0x0, .5);
    boundingbox.graphics.drawRect(r.x, r.y, r.width, r.height);
    boundingbox.graphics.endFill();

    stage.pointer.onDown.add((e) {
      var p = e.stagePosition;
//      e.stagePosition
//      print('${e.stagePosition} / global:${e.windowPosition}');
//      print(pink.hitTest(p));
      final tmpPoint = Pool.getPoint();
      pink.globalToLocal(p, tmpPoint);
      print(tmpPoint);
      print(pink.hitTest(tmpPoint));
    });

    return;
//    pink.x = 50 + 100.0;
//    pink.y = 50 + 140.0;
////    pink.scaleX = 3.5;
////    pink.scaleY = 3.25;
////    pink.rotation = .2;
////    pink.alignPivot(Alignment.bottomRight);
//
////    pink.scaleY = 1;
////    pink.rotation = .4;
////    pink.skewX = .2;
////    pink.skewY = .8;
//
////    pink.skewY = .;
////    pink.skewX = .4;
////    var r = green.getBounds(pink);
//    var r = pink.getBounds(green);
//
//    return;
////    var r = pink.getBounds(this);
////    var m = pink.getTransformationMatrix(pink.parent);
//
//    ///flutter: GxMatrix {a: 1.0, b: 1.260158217550339, c: 0.3093362496096232, d: 1.0, tx: 50.0, ty: 50.0}
////    print(r);
////    print(m);
////    var tl = m.transformCoords(r.left, r.top);
////    var tr = m.transformCoords(r.right, r.top);
////    var bl = m.transformCoords(r.left, r.bottom);
////    var br = m.transformCoords(r.right, r.bottom);
//
//    print(r);
//
//    void addPoint(GxPoint p, [bool isPivot = false]) {
//      boundingbox.graphics.lineStyle(0, 0x0, .5);
//      boundingbox.graphics.beginFill(Colors.yellow.value, .8);
//      var r = 4.0;
//      boundingbox.graphics.drawCircle(p.x, p.y, r);
//      boundingbox.graphics.endFill();
//
//      if (isPivot) {
//        boundingbox.graphics.lineStyle(.5, 0x0, .5);
//        boundingbox.graphics.moveTo(p.x, p.y - r);
//        boundingbox.graphics.lineTo(p.x, p.y + r);
//        boundingbox.graphics.moveTo(p.x - r, p.y);
//        boundingbox.graphics.lineTo(p.x + r, p.y);
//      }
//    }
//
////    addPoint(tl);
////    addPoint(tr);
////    addPoint(bl);
////    addPoint(br);
//
//    boundingbox.graphics.lineStyle(1, Colors.redAccent.value, .8);
//    boundingbox.graphics.drawRect(r.x, r.y, r.width, r.height);
//    boundingbox.graphics.endFill();
//
//    addPoint(GxPoint(pink.x, pink.y), true);
//    addPoint(GxPoint(r.x, r.y));

//    print("Aca esta! $r");
//    print(r);
//
//    var r2 = green.getBounds(pink);
//    print(r2);

//    box2.name = 'arbolito';
//    print(this);
//    print(box2);
//    print(stage);
//    var r = box.getBounds(box2);
//    var p2 = box2.localToGlobal(GxPoint());
//    var p1 = box.globalToLocal(p2);
//    print(p2);
//    print(p1);
//    print("r: $r");
//    print("x: ${box.x}");

//    boxes = List.generate(3, (index) {
//      return createBox(index);
//    });
//
//    var doc = Sprite();
//    addChild(doc);
//    doc.x = doc.y = 100;
////    Future.delayed(Duration(seconds: 2)).then(
////      (value) => addChild(doc),
////    );
//    var b1 = createBox(0);
//    b1.name = 'box1';
//    var b2 = createBox(4);
//    var b3 = createBox(6);
//    b2.name = 'box2';
//
//    doc.addChild(b3);
//    doc.addChild(b1);
//    doc.addChild(b2);
//
//    b1.x = 70;
//    b2.x = 50;
//    b3.x = 80;
//
//    b1.y += 10;
//    b2.y += 20;
//    b3.y += 30;

//    print(b2.getTransformationMatrix(b2.parent));
//    var r = doc.getBounds(this);
//    var r = b3.getBounds(this);
//    print(r);
////    doc.sortChildren((obj1, obj2) {
////      return obj1.x > obj2.x ? 1 : -1;
////    });
//    final st = Stopwatch();
//    stage.pointer.onDown.add((e) {
//      st.start();
//      st.reset();
//      var a = doc.hitTest(GxPoint.fromNative(e.position));
//      print(a);
////      doc.children.sort((a, b) {
////        return a.x > b.x ? 1 : -1;
////      });
//
////      doc.swapChildrenAt(0, 1);
////      doc.sortChildren((obj1, obj2) {
////        return obj1.x > obj2.x ? 1 : -1;
////      });
//      print(st.elapsedMilliseconds);
////      doc.addChild(doc.getChildAt(0));
////      doc.removeChildAt(0);
//      doc.removeChildren(1);
////      doc.setChildIndex(doc.getChildAt(0), 1);
//      st.stop();
////      doc.swapChildren(b1, b2);
//    });
//
////    doc.addChildAt(boxes[5], 0);
////    doc.addChildAt(boxes[1], 1);
//    addChild(doc);
//    doc.x = 100;
//    doc.y = 100;
  }

  Sprite createBox(int index) {
    var sprite = Sprite();
    addChild(sprite);

    var box = Shape();
    sprite.addChild(box);

//    box.x = 30 + 60.0 * index;
//    box.y = 100.0;
    box.graphics.beginFill(Colors.accents[index].value, 1);
    box.graphics.drawRect(0, 0, 40, 40);
    box.graphics.endFill();
    return sprite;
  }

  List<Shape> boxes;
}
