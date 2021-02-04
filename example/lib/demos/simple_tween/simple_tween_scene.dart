import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'my_box.dart';
import 'tween_controller.dart';

class SimpleTweenScene extends GSprite {
  final TweenSceneController controller;

  MyBox box;
  GSprite centeredContainer;

  SimpleTweenScene(this.controller);

  @override
  void addedToStage() {
    /// we can colorize the background of the scene.
    stage.color = Colors.grey.shade300;

    /// by default the Canvas drawing in Flutter has no "masking", you can paint
    /// anywhere on the screen (outside the stage size ).
    /// so to know which area is available to us, we can mask the stage, like
    /// culling, all objects outside the stage size, will not be visible.
    stage.maskBounds = true;

    /// use this Sprite to keep the box always centered in the stage.
    centeredContainer = GSprite();

    box = MyBox(size: 40);

    /// add the box as child of the container (will inherit all the
    /// transformations from the parent).
    centeredContainer.addChild(box);
    // add the container to the root scene.
    addChild(centeredContainer);

    /// now the box is drawn from the top left corner drawRect(0,0,width,height)
    /// so we can change the pivots so it centers itself in the parent
    box.alignPivot(Alignment.center);

    controller.onRotate.add(_rotateBox);
    controller.onScale.add(_scaleBox);
    controller.onTranslate.add(_moveBox);
    controller.onAddCounter.add(_addToCounter);

    _initCounter();

    /// listen for stage resize events.
    stage.onResized.add(_onStageResize);
  }

  GText counterText;

  /// There's support for several native types in GTween.
  /// double, int, Map, List, DisplayObject, GxPoint, GxRect..
  /// so the `twn` extension shortcut creates a `GTweenable` behind the scenes,
  /// which is the Type that GTween requires to tween.
  final counterValue = 0.twn;

  void _initCounter() {
    counterText = GText(
      textStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );

    addChild(counterText);
    counterText.text = 'hello counter!';
    // as the text is always at x=20, y=10, no need
    // to change position on stage resize.
    counterText.setPosition(20, 10);
  }

  void _addToCounter() {
    /// in the "raw" form of tween.
    //  GTween.to(counterValue, 1.0, {'value':100});

    /// Most GTweenable types have a `tween` shortcut extension.
    counterValue.tween('100', duration: 1.0, ease: GEase.slowMiddle,
        onUpdate: () {
      final counterString = counterValue.value.toString();
      counterText.text = 'counter: $counterString';
    });
  }

  void _moveBox(int dir) {
    if (dir == 0) {
      box.tween(duration: .5, x: 0, ease: GEase.elasticOut);
    } else {
      final relativeMove = 10.0 * dir;

      /// using Strings we can tween any value relative to the current value
      /// of the object.
      box.tween(duration: .5, x: '$relativeMove');
    }
  }

  void _scaleBox() {
    /// kill any running tweens on `box`
    GTween.killTweensOf(box);

    box.tween(
      duration: 1,
      scaleX: 2,
      ease: GEase.bounceOut,
    );

    box.tween(
        duration: 1,
        scaleY: 3,
        delay: .4,
        ease: GEase.bounceOut,
        onComplete: () {
          box.tween(
            duration: .4,
            scale: 1, // scale modifies scaleX, scaleY proportionally.
            ease: GEase.easeOutBack,
          );
        });
  }

  void _rotateBox() {
    /// kill any running tweens on `box`
    GTween.killTweensOf(box);

    box.tween(
      duration: 1.5,
      rotation: Math.PI_2, // radians, or use `deg2rad(360)`
      ease: GEase.easeInOutExpo,
      onComplete: () {
        box.tween(
          duration: .5,
          rotation: 0, // radians, or use `deg2rad(360)`
          ease: GEase.easeOutBack,
        );
      },
    );
  }

  void _onStageResize() {
    /// center in the Stage.
    centeredContainer.setPosition(
      stage.stageWidth / 2,
      stage.stageHeight / 2,
    );
  }
}
