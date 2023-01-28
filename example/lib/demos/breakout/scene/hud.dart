import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'game_scene.dart';

class HUD extends GSprite {
  // ignore: non_constant_identifier_names
  GText? _score_tf, _balls_tf, _gameState_tf, _speedUp_tf;
  final w = BreakoutAtari.gameW;
  final h = BreakoutAtari.gameH;

  HUD() {
    _draw();
  }

  void _draw() {
    const textMargin = 4.0;
    var titleScore = _getText('SCORE', 4);
    titleScore.setPosition(textMargin, textMargin);
    _score_tf = _getText('0', 6);
    _score_tf!.setPosition(textMargin, 10);

    var titleBall = _getText('BALL', 4);
    titleBall.alignPivot(Alignment.topRight);
    titleBall.setPosition(w - textMargin, textMargin);

    _balls_tf = _getText('3/3', 6);
    _balls_tf!.alignPivot(Alignment.topRight);
    _balls_tf!.setPosition(titleBall.x, 10);

    _gameState_tf = GText(
      text: 'GAME OVER',
      width: w,
      textStyle: const TextStyle(
        fontFamily: 'pressstart',
        fontSize: 12,
        color: Colors.white,
      ),
      paragraphStyle: ParagraphStyle(textAlign: TextAlign.center),
    );
    _gameState_tf!.y = (h - _gameState_tf!.textHeight) / 2;
    addChild(_gameState_tf!);

    _speedUp_tf = _getText('SPEED UP!', 10);
    _speedUp_tf!.alignPivot();
    _speedUp_tf!.setPosition(w / 2, h / 2);
    _speedUp_tf!.alpha = 0;

    setGameOver(false);
  }

  void showPoints(int points, GRect bounds) {
    var tmpContainer = GSprite();
    var p1Tf = GText(
      text: '+$points',
      textStyle: const TextStyle(
        fontFamily: 'pressstart',
        fontSize: 8,
        color: Colors.white,
      ),
    );

    final border = Paint();
    border.color = Colors.red;
    border.style = PaintingStyle.stroke;
    border.strokeWidth = .2;
    var p2Tf = GText(
      text: '+$points',
      textStyle: TextStyle(
        fontFamily: 'pressstart',
        fontSize: 8,
        foreground: border,
      ),
    );
    tmpContainer.addChild(p1Tf);
    tmpContainer.addChild(p2Tf);
    addChild(tmpContainer);
    tmpContainer.alignPivot(Alignment.bottomCenter);
    tmpContainer.x = bounds.x + bounds.width / 2;
    tmpContainer.y = bounds.y; //+ bounds.width / 2;
    // tmpContainer.$useSaveLayerBounds = false;
    tmpContainer.tween(
      duration: 1,
      y: '-10',
      ease: GEase.easeInQuad,
      alpha: 0,
      overwrite: 0,
      onComplete: () => tmpContainer.removeFromParent(true),
    );

    tmpContainer.tween(
      duration: .8,
      delay: .1,
      overwrite: 0,
      rotation: Math.randomBool() ? -.2 : .2,
      ease: GEase.easeOutQuad,
    );
  }

  void speedUp() {
    const offset = 10.0;
    GTween.killTweensOf(_speedUp_tf);
    _speedUp_tf!.y = h / 2;
    _speedUp_tf!.alpha = 0;
    _speedUp_tf!.tween(duration: .15, alpha: 1);
    _speedUp_tf!.tween(duration: 1.2, delay: .15, y: h / 2 - offset, alpha: 0);
  }

  GText _getText(String label, double size, [Shadow? shadow]) {
    var tf = GText(
      text: label,
      textStyle: TextStyle(
        fontFamily: 'pressstart',
        fontSize: size,
        shadows: shadow != null ? [shadow] : null,
        color: Colors.white,
      ),
    );
    addChild(tf);
    return tf;
  }

  void showPause(bool isPaused) {
    if (isPaused) {
      _gameState_tf!.text = 'PAUSED';
      _gameState_tf!.visible = true;
    } else {
      _gameState_tf!.visible = false;
    }
  }

  void showWin() {
    _gameState_tf!.text = 'YOU WIN!';
    _gameState_tf!.visible = true;
  }

  void setBalls(int numBalls, int maxBalls) {
    _balls_tf!.text = '$numBalls/$maxBalls';
    _balls_tf!.alignPivot(Alignment.topRight);
  }

  void setScore(int points) {
    _score_tf!.text = '$points';
  }

  void setGameOver(bool flag) {
    _gameState_tf!.visible = false;
    if (flag) {
      _gameState_tf!.text = 'GAME OVER';
      _gameState_tf!.visible = true;
    }
  }
}
