import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class ZoomPivotScene extends GSprite {
  @override
  void addedToStage() {
    stage!.color = Colors.white;

    var box = addChild(GSprite())
      ..setPosition(100, 100)
      ..graphics
          .beginFill(Colors.yellow) //
          .drawRect(0, 0, 100, 100) //
          .endFill();

    var boxPivot = box.addChild(GShape())
      ..graphics.beginFill(Colors.blue).drawCircle(0, 0, 2).endFill();

    /// Some random transformations to box2 to show
    /// accuracy of child interactions.
    var box2 = addChild(GSprite());
    box2.graphics
        .beginFill(Colors.red.withOpacity(.2))
        .drawRect(0, 0, 400, 400)
        .endFill();
    box2.addChild(box);
    box2.setPosition(100, 100);

    /// Comment the following code lines to remove the extra transforms to
    /// the parent container... shows that the pivot is still accurate on nested
    /// transformations.
    stage!.onEnterFrame.add((time) {
      var t = stage!.controller.ticker!.currentTime / 3;
      box2.scaleX = 1 + Math.sin(t) * .5;
      box2.scaleY = 1 - Math.cos(t) * .5;
      box2.skewY = .1 + Math.cos(t) * .25;
      box2.skewX = .2 + Math.cos(t) * .15;
    });

    // --------------------
    var dpr = window.devicePixelRatio;
    box.onMouseDown.add((event) {
      boxPivot.x = box.pivotX = box.mouseX;
      boxPivot.y = box.pivotY = box.mouseY;
      box.x = box.parent!.mouseX;
      box.y = box.parent!.mouseY;

      stage!.onMouseMove.add((event) {
        box.x = box.parent!.mouseX;
        box.y = box.parent!.mouseY;
      });
      stage!.onMouseUp.addOnce((event) {
        stage!.onMouseMove.removeAll();
      });
    });

    // Regular mouse support + magic mouse/trackpad on web target.
    box.onMouseScroll.add((event) {
      boxPivot.x = box.pivotX = box.mouseX;
      boxPivot.y = box.pivotY = box.mouseY;
      box.x = box.parent!.mouseX;
      box.y = box.parent!.mouseY;

      var scaleRatio = (event.scrollDelta.y / dpr) / 100;

      /// Shift Key flips Mouse Wheel (horizontal scroll).
      var rotationRatio = (event.scrollDelta.x / dpr) / 100;

      box.rotation += rotationRatio;
      box.scale += scaleRatio;
      box.scale = box.scale.clamp(.25, 10);
    });

    /// zoom / pan (trackpad and some horizontal mouse wheel on macos)
    var grabScale = 1.0, grabRot = 0.0;
    box.onZoomPan.add((event) {
      var e = event.rawEvent!.rawEvent;
      if (e is PointerPanZoomStartEvent) {
        grabScale = box.scale;
        grabRot = box.rotation;

        boxPivot.x = box.pivotX = box.mouseX;
        boxPivot.y = box.pivotY = box.mouseY;
        box.x = box.parent!.mouseX;
        box.y = box.parent!.mouseY;
      } else if (e is PointerPanZoomUpdateEvent) {
        if (e.scale == 1 && e.rotation == 0) {
          // if we do use a mouse or trackpad to scroll horizontally...
          // emulate mouse wheel. (macOS)
          var scaleRatio = (e.panDelta.dy / dpr) / 100;
          var rotationRatio = (e.panDelta.dx / dpr) / 100;

          if (rotationRatio == 0 &&
              GKeyboard.isDown(LogicalKeyboardKey.shift)) {
            rotationRatio = scaleRatio;
            scaleRatio = 0;
          }
          box.scale += scaleRatio;
          box.rotation += rotationRatio;
        } else {
          box.rotation = grabRot - e.rotation;
          box.scale = grabScale + (e.scale - 1);
        }

        /// limit scale to 10% and 1000%.
        box.scale = box.scale.clamp(.1, 10);
      }
    });
  }
}
