import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphx/demos/simple_game/utils/game_mixins.dart';
import 'package:graphx/graphx/core/graphx.dart';
import 'package:graphx/graphx/utils/pools.dart';

import 'bullet.dart';

class Ship extends Sprite with GameObject {
  Ship() {
    init();
  }

  double w = 20;
  double h = 30;
  Shape _shape;
  Sprite _shield;

  double ar = 0;
  int dirR = 0;
  double vr = .01;

  double at = 0;
  double dirT = 0;
  double vt = 0.8;
  static const minVT = .8;
  static const maxVT = 1.5;
  var stopWatch = Stopwatch();

  Shape _shooter1;
  Shape _shooter2;

  void init() {
    _shape = Shape();
    stopWatch.start();
    final w2 = w / 2;
    _shape.graphics
        .lineStyle(0, Colors.cyan.value, 1)
        .moveTo(0, 0)
        .lineTo(-w2, h)
        .lineTo(w2, h)
        .lineTo(0, 0);

    double turbineH = 4.0;
    double turbineW = 6.0;
    _shape.graphics.drawRect(-w / 2, h + 2, turbineW, turbineH);
    _shape.graphics.drawRect(w / 2 - turbineW, h + 2, turbineW, turbineH);
    _shape.graphics.endFill();

    final o2 = 14.0;
    _shape.graphics
        .lineStyle(0, Colors.cyan.value, .5)
        .moveTo(0, o2)
        .lineTo(-w2 - o2, h)
        .lineTo(w2 + o2, h)
        .lineTo(0, o2);

    _shooter1 = createShooter();
    _shooter2 = createShooter();
    _shooter1.setPosition(-w2 - o2, h - o2 / 2);
    _shooter2.setPosition(w2 + o2 - 2, h - o2 / 2);

    _shape.graphics.endFill();
    _shape.graphics.lineStyle(0, Colors.cyan.value, .85);
    _shape.graphics.drawEllipse(0, h / 2, 2, 4);
    _shape.graphics.endFill();

    addChild(_shape);
    alignPivot();

    _createShield();
  }

  void toggleShield() {
    _shield.visible = !_shield.visible;
  }

  double shieldExpansion = 0.0;

  void _updateShield() {
    if (!_shield.visible) return;
    shieldExpansion += .07;
    var si = sin(shieldExpansion);
//    var si2 = sin(shieldExpansion / 1.2);

    void _transformShield(IAnimatable obj, double sino, [double rotDir]) {
      var p = .5 + sino / 2;
      obj.alpha = 0.13 + (1 - p) * .45;
//      obj.scale = 0.8 + p * .4;
      obj.skewX = sino; //-si * .5;
      obj.skewY = -sino / 2; //-si * .5;
      obj.rotation += rotDir;
    }

    /// tunning independently.
    _transformShield(_shield.getChildAt(0), si, .02);
    _transformShield(_shield.getChildAt(1), -si, -.01);
  }

  void _createShield() {
    _shield = Sprite();
    _addShieldCircle() {
      var shape = Shape();
      shape.graphics.lineStyle(2, Colors.lightGreenAccent.value, 1)
        ..drawCircle(0, 0, h * 1.2).endFill();
      _shield.addChild(shape);
    }

    _addShieldCircle();
    _addShieldCircle();

    addChild(_shield);
//    _shield.alignPivot();
    _shield.x = pivotX;
    _shield.y = pivotY;
    _shield.visible = false;
  }

  void update() {
    _updateKeyboard();
    ar += vr * dirR;
    ar *= .8;
    rotation += ar;

    var ang = rotation - pi / 2;

    at += vt * dirT;
    at *= .9;
    var px = cos(ang) * at;
    var py = sin(ang) * at;
    x += px;
    y += py;
    _updateCanions();
    _updateBullets();
    _updateShield();
  }

  void _updateCanions() {
    double v1 = _shooter1.userData;
    double v2 = _shooter2.userData;
    _shooter1.scaleY += (v1 - _shooter1.scaleY) / 8;
    _shooter2.scaleY += (v2 - _shooter2.scaleY) / 8;
  }

  void _updateKeyboard() {
    final isPressed = stage.keyboard.isPressed;
    final isUp = isPressed(LogicalKeyboardKey.arrowUp);
    final isDown = isPressed(LogicalKeyboardKey.arrowDown);
    final isLeft = isPressed(LogicalKeyboardKey.arrowLeft);
    final isRight = isPressed(LogicalKeyboardKey.arrowRight);
    final isShift = stage.keyboard.isShiftPressed;
    final isSpacebar = isPressed(LogicalKeyboardKey.space);

    if (isSpacebar) shoot();

    if (isLeft) {
      dirR = -1;
    } else if (isRight) {
      dirR = 1;
    } else {
      dirR = 0;
    }
    double extraThrust = isShift ? 2 : 1;
    if (isUp) {
      dirT = 1 * extraThrust;
    } else if (isDown) {
      dirT = -1 * extraThrust;
    } else {
      dirT = 0;
    }
  }

  int lastShot = 0;

  void shoot() {
    var ts = stopWatch.elapsedMilliseconds;
    if (ts - lastShot < 100) {
      return;
    }
    lastShot = ts;

    var canion = _bullets.length.isOdd ? _shooter1 : _shooter2;
    canion.scaleY = 3;
    canion.userData = 1.0;
    final tmpPoint = Pool.getPoint();
    canion.localToGlobal(tmpPoint, tmpPoint);

    var bullet = Bullet(this);
    bullet.shape.setPosition(tmpPoint.x, tmpPoint.y);
    bullet.shape.rotation = rotation + pi / 2;
    bullet.acc += at;
    bullet.calculateAngle();
    _bullets.add(bullet);

    /// put back used pooled point instance.
    Pool.putPoint(tmpPoint);
    parent.addChild(bullet.shape);
  }

  List<Bullet> _bullets = [];

  void _updateBullets() {
    for (var i = 0; i < _bullets.length; ++i) {
      var b = _bullets[i];
      b.update();
    }
  }

  Shape createShooter() {
    var sh = Shape();
    addChild(sh);
    sh.userData = 1.0;
    sh.graphics.lineStyle(0, Colors.cyan.value, .85);
    sh.graphics.drawRect(0, 0, 2, 6);
    sh.graphics.endFill();
    return sh;
  }

  void removeBullet(Bullet b) {
    _bullets.remove(b);
    b.dispose();
  }
}
