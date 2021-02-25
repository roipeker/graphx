/// Ismail Alam Khan, 2020.
///
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class ToastScene extends GSprite {
  GSprite container;
  GShape bg;
  GSprite button;
  GShape buttonGShape;
  GText text;
  GText buttonText;
  GIcon myIcon;

  @override
  void addedToStage() {
    mps.on('showSnackBar', _onShowSnackbar);
    mps.on('keyboardOpened', _changeSnackDirection);
    container = GSprite();
    button = GSprite();

    bg = GShape()
      ..graphics
          .beginFill(Color(0xffff00ff))
          .drawRoundRect(
            0,
            0,
            stage.stageWidth - 20,
            60,
            10,
          )
          .endFill();
    buttonGShape = GShape()
      ..graphics
          .beginFill(Colors.transparent)
          .drawRoundRect(0, 0, 80, 40, 10)
          .endFill();

    myIcon = GIcon(Icons.info)..setPosition(10, 17);

    final paragraphStyle = ParagraphStyle(maxLines: 2, ellipsis: '...');
    text = GText(
      text: '',
      width: stage.stageWidth - 150,
      paragraphStyle: paragraphStyle,
      textStyle: TextStyle(fontSize: 18, color: Colors.white),
    )
      ..x = myIcon.x + 30
      ..y = 13;
    buttonText = GText(
      text: 'Increment',
      width: stage.stageWidth - 150,
      paragraphStyle: paragraphStyle,
      textStyle: TextStyle(fontSize: 14, color: Colors.white),
    )
      ..y = 11
      ..x = 9;
    addChild(container);
    container
      ..x = 10
      ..y = stage.stageHeight + 20
      ..addChild(bg)
      ..addChild(text)
      ..addChild(myIcon)
      ..addChild(button);
    button..addChild(buttonGShape)..addChild(buttonText);
  }

  void _onShowSnackbar(Map<String, dynamic> value) {
    text.text = value['text'];
    bg.colorize = value['color'];
    bg.width = stage.stageWidth - 20;
    button
      ..x = stage.stageWidth - 120
      ..y = 10
      ..onMouseClick(value['onMouseClick']);

    show(value['bottomInset']);
  }

  void _changeSnackDirection(double bottom) {
    final open = bottom != 0;
    if (container.y <= stage.stageHeight) {
      if (open) {
        show(bottom);
      } else {
        show(bottom);
      }
    }
  }

  void show(double bottom) {
    var targetY = (stage.stageHeight - container.height - 10) - bottom;
    container.tween(
      y: targetY,
      duration: 1,
      ease: GEase.bounceOut,
    );
    bg.tween(
      duration: 1,
      alpha: 1,
    );

    GTween.killTweensOf(hide);
    GTween.delayedCall(5, hide);
  }

  void hide() {
    container.tween(
      duration: 1,
      ease: GEase.elasticIn,
      y: stage.stageHeight + 20,
    );
    GTween.delayedCall(.8, () {
      bg.tween(
        duration: 1,
        alpha: 0,
      );
    });
  }
}
