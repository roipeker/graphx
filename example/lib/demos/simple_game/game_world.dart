import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'objects/background.dart';
import 'objects/bullet.dart';
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
    loadAssets();

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
    explodeEnemy(enemy);
    enemy.dispose();
    enemies.remove(enemy);
  }

  void update(double delta) {
    ship.update();
    constrainShip();
    bg.update();
    updateEnemies();
    updateGfx(delta);
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

  void updateGfx(double delta) {
    for (var i = 0; i < explosions.length; ++i) {
      explosions[i].update(delta);
    }
  }

  void explodeEnemy(BasicEnemy enemy) {
    var mc = MovieClip(frames: explosionFrames, fps: 25);
    mc.repeatable = false;
    mc.reversed = false;
    mc.nativePaint.blendMode = BlendMode.screen;
    mc.onFramesComplete.addOnce(() {
      explosions.remove(mc);
      mc.removeFromParent(true);
    });

    //// add particle?
    addParticle(enemy);

    mc.gotoAndPlay(0);
    mc.setPosition(enemy.x - mc.width / 2, enemy.y - mc.width / 2);
    addChild(mc);
    explosions.add(mc);
  }

  List<SimpleParticleSystem> particlesList = [];

  var starParticle = Graphics()
    ..beginFill(0xff00ff, 1)
    ..drawStar(0, 0, 5, 9)
    ..endFill();

  void addParticle(BasicEnemy enemy) {
    /// LEARN TO ADD PARTICLES!
    var pp = SimpleParticleSystem();
    pp.useWorldSpace = true;
    pp.setPosition(enemy.x + 16, enemy.y + 16);
    pp.scale = .5;
    pp.texture = particle_tx;
    pp.setup();
    pp.init();
    addChild(pp);

    pp.emission = 100;
    pp.emissionTime = 4;
    pp.energy = 5;
    pp.burst = true;
    pp.emit = true;

    pp.dispersionAngleVariance = deg2rad(360);
    pp.dispersionAngle = deg2rad(40);
    pp.initialVelocity = 20;
    pp.initialVelocityVariance = 20;
//    pp.initialAngleVariance = 2;
//    pp.initialAlphaVariance = .55;
    pp.initialAlphaVariance = .5;
//    pp.initialAngularVelocity = .001;
//    pp.initialAngularVelocityVariance = .2;
//    pp.initialAngleVariance = 3;
    pp.initialAngularVelocityVariance = .4;
//    pp.initialScaleVariance = 2;
    pp.endAlpha = 0;

    pp.initialColor = Colors.amber.value;
    pp.endColor = Colors.cyan.value;
    pp.initialScale = .4;
    pp.endScale = 1;
    pp.endScaleVariance = .4;

    /*pp.drawCallback = (canvas, paint) {
      starParticle.paintWithFill(canvas, paint);
    };*/

//    pp.initialColor = Colors.purpleAccent.value;
    pp.useAlphaOnColorFilter = true;
    pp.blendMode = BlendMode.srcATop;
    particlesList.add(pp);
  }

  var explosions = <MovieClip>[];
  final explosionFrames = <GxTexture>[];
  GxTexture particle_tx;

  void loadAssets() async {
    var explosion_tx =
        await AssetLoader.loadImageTexture('assets/game/exp2.jpg');
    explosionFrames.addAll(
      TextureUtils.getRectAtlasFromTexture(explosion_tx, 64),
    );

    particle_tx =
        await AssetLoader.loadImageTexture('assets/game/flare/sparkle.png', 3);
//    var bmp = Bitmap(p_tx);
  }
}
