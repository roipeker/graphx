import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graphx/graphx/display/shape.dart';
import 'package:graphx/graphx/core/scene_painter.dart';

class MainFrontScene extends RootScene {
  @override
  void init() {
    /// setup the controller from within the Scene.
    owner.core.config.useTicker = true;
    owner.core.config.usePointer = true;
  }

  Shape yellowCircle;

  @override
  void ready() {
    super.ready();
    yellowCircle = Shape();
    yellowCircle.graphics.beginFill(0xffff00, .8);
    yellowCircle.graphics.drawCircle(0, 0, 120);
    yellowCircle.graphics.endFill();

    addChild(yellowCircle);
    stage.onEnterFrame.add(() {
      yellowCircle.x = stage.pointer.mouseX;
      yellowCircle.y = stage.pointer.mouseY;
    });
  }
}

class MainBackScene extends RootScene {
  /// access to the other "scene layer"
  MainFrontScene get frontRoot => owner.core.front.root as MainFrontScene;

  var redCircle = Shape();

  @override
  void ready() {
    super.ready();
    stage.color = 0xffffffff;
    stage.x = 100;
    stage.y = 50;
    redCircle.graphics.beginFill(0xff0000, 1);
    redCircle.graphics.drawCircle(0, 0, 30);
    redCircle.graphics.endFill();
    addChild(redCircle);
    stage.onEnterFrame.add(() {
      redCircle.x = frontRoot.yellowCircle.x;
      redCircle.y = frontRoot.yellowCircle.y;
    });

    stage.pointer.onDown.add((e) {
      if (contains(redCircle)) {
        frontRoot.addChild(redCircle);
        addChild(frontRoot.yellowCircle);
      } else {
        addChild(redCircle);
        frontRoot.addChild(frontRoot.yellowCircle);
      }
    });
  }
}

class MyAvatarBack extends RootScene {
  MyAvatarBack();

  @override
  void init() {
    owner.useOwnCanvas = false;
  }

  @override
  void ready() {
    super.ready();
    var redCircle = new Shape();
    redCircle.graphics.beginFill(Colors.lightGreen.value, .85);
    redCircle.graphics.drawCircle(0, 0, 24);
    redCircle.graphics.endFill();

    addChild(redCircle);
    redCircle.x = stage.stageWidth / 2;
    redCircle.y = stage.stageHeight / 2;

    double count = 0;
    var tw = stage.stageWidth / 2;
    var th = stage.stageHeight / 2;
//    stage.onEnterFrame.add(() {
//      count += .1;
//      redCircle.scaleX = .4 + (.5 + sin(count / 2) / 2) * 1.2;
//      redCircle.y = th + sin(count) * th;
//    });
  }
}

class MyAvatarFront extends RootScene {
  Function(bool) handleDragging;

  MyAvatarFront(this.handleDragging) {
    print("Recreate constructor!");
  }

  @override
  void init() {
    owner.core.config.usePointer = true;
    owner.core.config.useTicker = true;
    owner.useOwnCanvas = false;
    owner.needsRepaint = true;
    print("Create me!");
  }

  @override
  void ready() {
    super.ready();
    owner.core.resumeTicker();

    var box = new Shape();
    addChild(box);

    var star = new Shape();
//    star.graphics.lineStyle(4, Colors.redAccent.value, 1);
    star.graphics.beginFill(Colors.redAccent.value, 1);
    star.graphics.drawStar(0, 0, 6, 10.0);
//    redCircle.graphics.drawCircle(0, 0, 9);
    star.graphics.endFill();
    star.x = stage.stageWidth - 10;
    star.y = stage.stageHeight - 10;

//    redCircle.graphics.beginFill(Colors.amberAccent.value, .8);
//    redCircle.graphics.drawCircle(0, 0, 3);
//    redCircle.graphics.endFill();

    addChild(star);
//    star.x = stage.stageWidth / 2;
//    star.y = stage.stageWidth / 2;

    double count = 0;
    var tw = stage.stageWidth / 2;
    stage.onEnterFrame.add(() {
      count += .1;
      star.y = tw + -cos(count / 3) * tw / 2;
      star.x = tw + cos(count) * tw;
      star.scaleX = cos(count / 2);
//      if (stage.pointer.isDown) {
//        star.y = stage.pointer.mouseY;
//        star.x = stage.pointer.mouseX;
//      }
    });

    bool isPressed = false;
    void drawBox(int color) {
      box.graphics.clear();
      box.graphics.beginFill(color, .85);
      box.graphics.drawRect(0, 0, 40, 40.0);
      box.graphics.endFill();
    }

    stage.pointer.onExit.add((e) {
      if (isPressed) return;
      drawBox(Colors.red.value);
    });

    stage.pointer.onEnter.add((e) {
      print("ENTER");
      if (isPressed) return;
      drawBox(Colors.blue.value);
    });

//    stage.pointer.onHover.add((e) {
//      print("HOVER!");
//    });
    stage.pointer.onDown.add((e) {
      isPressed = true;
      drawBox(Colors.green.value);
      stage.pointer.onUp.addOnce((e) {
        isPressed = false;
//        if (!box.getBounds(40, 40).contains(e.localX, e.localX)) {
//          drawBox(Colors.red.value);
//        }
      });
    });

//    stage.pointer.onDown.add((e) {
//      handleDragging?.call(true);
//      owner.needsRepaint = true;
//      owner.core.resumeTicker();
//      final local = e.rawEvent.localPosition;
//      final global = e.rawEvent.position;
//      print('Local: $local - global: $global');
//    });
//    stage.pointer.onUp.add((e) {
//      handleDragging?.call(false);
//      owner.core.pauseTicker();
//      owner.needsRepaint = false;
//    });
  }
}
