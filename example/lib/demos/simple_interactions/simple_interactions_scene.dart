import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'ui/my_button.dart';

class SimpleInteractionsScene extends GSprite {
  late GShape ball;

  @override
  void addedToStage() {
    var button = MyButton();
    addChild(button);
    button.alignPivot();
    button.mouseUseShape = true;

    /// We can listen for the same Signals the button is listening
    /// internally.
    // button.onMouseDown.add((e) => print("mouse down on button! $e"));

    stage!.onResized.add(() {
      button.x = stage!.stageWidth / 2;
      button.y = stage!.stageHeight / 2;
    });

    _initBall();
  }

  void _initBall() {
    /// a ball to play with the keyboard
    ball = GShape();
    ball.name = 'ball';
    ball.graphics.lineStyle(6);
    ball.graphics.beginFill(Colors.red);
    ball.graphics.drawCircle(0, 0, 20);
    ball.graphics.endFill();
    addChild(ball);
    ball.x = 100;
    ball.y = 100;

    stage!.keyboard!.onDown.add(_onKeyboardDown);
    stage!.keyboard!.onUp.add(_onKeyboardUp);
  }

  /// Only the stage has access to keyboard events.
  /// Through the `KeyboardManager`, we can check which key is pressed.
  /// And also access the `rawEvent` dispatched by Flutter if we need to.
  /// Most of the times you are ok using `LogicalKeyboardKey` to check
  /// for the keyboard's keys constants.
  /// Usually [onDown] fires keystrokes in constantly, although it depends
  /// on the OS and keyboard, while you keep it pressed.
  void _onKeyboardDown(KeyboardEventData event) {
    var pixelsToMove = 10.0;

    /// for access modifiers keys, is better to check the raw event itself.
    /// as multiple physical keys have the same behaviour (shift, command,
    /// alt, etc) but different key codes.
    if (event.rawEvent.isShiftPressed) {
      pixelsToMove = 30.0;
    }

    /// keyboard arrows has shortcuts for easier check.
    if (event.arrowLeft) {
      ball.x -= pixelsToMove;
    } else if (event.arrowRight) {
      ball.x += pixelsToMove;
    }

    /// or for custom keys, we can use the other ways to check for the
    /// current pressed key.
    if (event.isKey(GKey.arrowUp)) {
      // arrow key UP
      ball.y -= pixelsToMove;
    } else if (event.rawEvent.logicalKey == GKey.arrowDown) {
      // arrow key DOWN
      ball.y += pixelsToMove;
    }
  }

  /// [onUp], unlike [onDown], dispatches only once, when you release a
  /// keystroke. use the A for scale down the ball, and S to scale it up
  /// by 20% on each event.
  void _onKeyboardUp(KeyboardEventData event) {
    if (event.isKey(GKey.keyS)) {
      ball.scale += .2;
    } else if (event.isKey(GKey.keyA)) {
      ball.scale -= .2;
    }
  }
}
