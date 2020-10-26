import 'package:flutter/services.dart';
import 'package:graphx/demos/simple_game/objects/bullet.dart';
import 'package:graphx/gameutils.dart';
import 'package:graphx/graphx/graphx.dart';
import 'package:graphx/graphx/utils/math_utils.dart';
import 'package:graphx/graphx/utils/pools.dart';

import 'objects/background.dart';
import 'objects/enemy.dart';
import 'objects/ship.dart';

class GameWorld extends Sprite {
  static GameWorld instance;

  Ship ship;
  Sprite bullets;
  GameBackground bg;
  List<BasicEnemy> enemies = [];

  void init() {
    instance = this;
    initUI();
  }

//  StaticText score;

  void initUI() {
//    stage.color = 0xff232323;
    stage.color = 0xff0000000;
    bg = GameBackground();
    bullets = Sprite();
    ship = Ship();
    ship = Ship();
    ship.setPosition(100, 100);
//    _initScore();
    addChild(bg);
    addChild(bullets);
    addChild(ship);
//    addChild(score);
    _createEnemies();
  }

  void spawnEnemy() {
    var enemy = BasicEnemy();
//    enemy.$debugBounds = true;

    bool startsLeft = GameUtils.rndBool();
    double minAng = 180 - 60.0;
    double maxAng = 180 + 60.0;
    double startX = stage.stageWidth;
    double startY = GameUtils.rndRange(80, stage.stageHeight - 80);

    if (startsLeft) {
      startX = 0;
      minAng += 180;
      maxAng += 180;
    }

    enemy.setPosition(startX, startY);
    enemy.angularDir = GameUtils.rndRange(
      deg2rad(minAng),
      deg2rad(maxAng),
    );
    enemy.angularVel = GameUtils.rndRange(.5, 1.8);
    addChild(enemy);
    enemies.add(enemy);
  }

  void removeEnemy(BasicEnemy enemy) {
    enemy.dispose();
    enemies.remove(enemy);
  }

  void update() {
    ship.update();
    constrainShip();
    bg.update();
    updateEnemies();
  }

  void updateEnemies() {
    for (var i = 0; i < enemies.length; ++i) {
      enemies[i].update();
    }
  }

  void constrainShip() {
    constrainInBounds(ship);
  }

  void constrainInBounds(DisplayObject obj) {
    if (obj.x > stage.stageWidth) obj.x = 0;
    if (obj.x < 0) obj.x = stage.stageWidth;
    if (obj.y > stage.stageHeight) obj.y = 0;
    if (obj.y < 0) obj.y = stage.stageHeight;
  }

  bool isOutBounds(DisplayObject obj, [double radius = 0]) {
    return obj.x > stage.stageWidth + radius ||
        obj.x < -radius ||
        obj.y > stage.stageHeight + radius ||
        obj.y < -radius;
  }

  void _createEnemies() {
    spawnEnemy();
    Future.delayed(Duration(seconds: 2), _createEnemies);
  }

  void bulletHitEnemy(Bullet bullet) {
    var bulletPos = Pool.getPoint(bullet.shape.x, bullet.shape.y);
    var localPos = Pool.getPoint();
    for (var i = 0; i < enemies.length; ++i) {
      final enemy = enemies[i];
      enemy.globalToLocal(bulletPos, localPos);
//      var d = bulletPos
      if (enemy.hitTest(localPos) != null) {
        removeEnemy(enemy);
      }
    }
    Pool.putPoint(bulletPos);
    Pool.putPoint(localPos);
  }

  void handleKeyboard(KeyboardEventData e) {
    if (e.isPress(LogicalKeyboardKey.keyU)) {
      ship.toggleShield();
    }
  }
}
