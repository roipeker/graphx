import 'package:flutter/material.dart';
import 'package:graphx/graphx/display/shape.dart';
import 'package:graphx/graphx/display/sprite.dart';
import 'package:graphx/graphx/scene_painter.dart';

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

    boxes = List.generate(10, (index) {
      return createBox(index);
    });

    var doc = Sprite();
    addChild(doc);
    doc.x = doc.y = 100;

//    Future.delayed(Duration(seconds: 2)).then(
//      (value) => addChild(doc),
//    );
    var b1 = createBox(0);
    b1.name = 'box1';
    var b2 = createBox(4);
    b2.name = 'box2';
    doc.addChild(b1);
    doc.addChild(b2);

    b1.x = 70;
    b2.x = 50;
//    stage.pointer.onDown.add((e) {
//      doc.swapChildren(b1, b2);
//    });
//
////    doc.addChildAt(boxes[5], 0);
////    doc.addChildAt(boxes[1], 1);
//    addChild(doc);
//    doc.x = 100;
//    doc.y = 100;
  }

  Shape createBox(int index) {
    var box = Shape();
    addChild(box);
    box.x = 30 + 60.0 * index;
    box.y = 100.0;
    box.graphics.beginFill(Colors.accents[index].value, 1);
    box.graphics.drawRect(0, 0, 40, 40);
    box.graphics.endFill();
    return box;
  }

  List<Shape> boxes;
}
