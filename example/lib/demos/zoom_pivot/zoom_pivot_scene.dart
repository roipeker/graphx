import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class ZoomPivotScene extends GSprite {

  late GSprite box;
  late GShape boxPivot;

  @override
  void addedToStage() {
    stage!.color = Colors.white;

    /// Main interaction box (yellow)
    box = addChild(GSprite())
      ..setPosition(100, 100)
      ..graphics
          .beginFill(Colors.yellow) //
          .drawRect(0, 0, 100, 100) //
          .endFill();

    /// Tiny blue dot to identify local (0,0) coordinate in `box`.
    /// Mo
    boxPivot = box.addChild(GShape())
      ..graphics.beginFill(Colors.blue).drawCircle(0, 0, 2).endFill()
      ..name = 'dot';

    /// Some random transformations to box2 to show
    /// accuracy of child interactions.
    /// A container for [box] with extra transformations.
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
    /// WARNING: Mouse interactions on [box] are only valid when the the mouse
    /// is HOVERING it. So if you have a hard time testing the zoom+pan comment
    /// this code.
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
      centerOnMouse();

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
      centerOnMouse();

      // We use `100` cause is the "size" of the [box].
      // To get 1% of the box size per mouse wheel tick "delta" we divide by 100.
      // If you change the size of the box, you need to change this value.
      // If you are on Windows probably [scrollDelta] will not provide a proper
      // speed value, and you should "adjust" the ratio accordingly to your needs,
      // on my tests, macOS reports accurate values for mouse wheel "ticks" and
      // trackpad gestures... this provides an accurate control over the
      // zoom. On Windows numbers are extremely high, so you need to add a
      // bigger ratio to get a proper zoom speed (from 20x to 100x more for [scrollDelta]).
      // Linux was not tested.
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
      var rawEvent = event.rawEvent!.rawEvent;
      if (rawEvent is PointerPanZoomStartEvent) {
        grabScale = box.scale;
        grabRot = box.rotation;
        centerOnMouse();
      } else if (rawEvent is PointerPanZoomUpdateEvent) {
        if (rawEvent.scale == 1 && rawEvent.rotation == 0) {
          // if we do use a mouse or trackpad to scroll horizontally...
          // emulate mouse wheel. (macOS)
          var scaleRatio = (rawEvent.panDelta.dy / dpr) / 100;
          var rotationRatio = (rawEvent.panDelta.dx / dpr) / 100;

          if (rotationRatio == 0 &&
              GKeyboard.isDown(LogicalKeyboardKey.shift)) {
            rotationRatio = scaleRatio;
            scaleRatio = 0;
          }
          box.scale += scaleRatio;
          box.rotation += rotationRatio;
        } else {
          box.rotation = grabRot - rawEvent.rotation;
          box.scale = grabScale + (rawEvent.scale - 1);
        }

        /// limit scale to 10% and 1000%.
        box.scale = box.scale.clamp(.1, 10);
      }
    });
  }

  void centerOnMouse() {
    // 1 - adjust pivot point (0,0) for [box], and match the inner
    // [boxPivot] to that pivot (0,0).
    // Pivot is ALWAYS relative to the parent. Inside a GSprite it has it's own
    // coordinates, that's why we have to move [boxPivot]
    boxPivot.x = box.pivotX = box.mouseX;
    boxPivot.y = box.pivotY = box.mouseY;

    // 2 - match the position of [box] in parent's mouse position coordinates.
    box.x = box.parent!.mouseX;
    box.y = box.parent!.mouseY;
  }
}
