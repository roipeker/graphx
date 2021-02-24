import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'data.dart';
import 'hud.dart';
import 'objects.dart';

class BreakoutAtari extends GSprite {
  static const double gameW = 160;
  static const double gameH = 192;

  static BreakoutAtari instance;

  final bricks = <Brick>[];

  int maxBalls = 3, numBalls = 3;
  int score = 0;

  bool isDragging = false;
  double stagePressX = 0;
  double paddlePressX = 0;

  /// 160 x 192.
  double brickGap = 2.0;
  double brickW = 25.0;
  double brickH = 12.0;
  final wallW = 4.0;

  int cols, rows;
  double totalBrickSep;

  Paddle paddle;
  Ball ball;
  GSprite bicksContainer;
  HUD hud;

  bool movingLeft = false;
  bool movingRight = false;
  bool _isGameOver = false;
  int brokenBricksCount = 0;

  double get sw => stage.stageWidth;

  double get sh => stage.stageHeight;

  BreakoutAtari() {
    instance = this;
  }

  void _resumeGame() {
    if (ball.isStopped) {
      if (_isGameOver) {
        _newGame();
      }
      ball.setVelocity(ball.speed);
    }
  }

  void _newGame() {
    _resetBall();
    numBalls = maxBalls;
    score = 0;
    _buildBricks();

    hud.setBalls(numBalls, maxBalls);
    hud.setScore(score);
    _gameOver(false);
  }

  void _gameOver(bool flag) {
    _isGameOver = flag;
    hud.setGameOver(_isGameOver);
  }

  void _winGame() {
    _isGameOver = true;
    hud.showWin();
    // hud.setBalls(numBalls, maxBalls);
    _resetBall();
  }

  void _loseLife() {
    if (--numBalls == 0) {
      _gameOver(true);
    }
    hud.setBalls(numBalls, maxBalls);
    _resetBall();
    mps.emit1(GameEvents.gameOver, false);
  }

  void _buildBricks() {
    /// clear old bricks if any.
    for (var brick in bricks) {
      brick.removeFromParent(true);
    }
    bricks.clear();
    final total = rows * cols;
    final sepHud = 20;
    for (var i = 0; i < total; ++i) {
      final idx = i % cols;
      final idy = i ~/ cols;
      var colorIndex = kLevelData[idy][idx];
      var brick = Brick();
      brick.points = colorIndex * 2;
      brick.init(brickW, brickH, kColorMap[colorIndex]);
      brick.x = wallW + idx * (brickGap + brickW);
      brick.y = sepHud + wallW + idy * (brickGap + brickH);
      bicksContainer.addChild(brick);
      bricks.add(brick);
    }
  }

  @override
  void addedToStage() {
    mps.on(GameEvents.action, (flag) {
      if (ball.isStopped) {
        isPaused = false;
        _updatePause();
        _resumeGame();
      } else {
        isPaused = flag;
        _updatePause();
      }
    });
    stage.onMouseDown.add((event) {
      isDragging = true;
      stagePressX = mouseX;
      paddlePressX = paddle.x;
      stage.onMouseUp.addOnce((event) {
        isDragging = false;
      });
    });
    // stage.color = Colors.black.value;
    // stage.showBoundsRect = true;
    stage.maskBounds = true;
    stage.keyboard.onUp.add((input) {
      if (input.isKey(LogicalKeyboardKey.escape)) {
        isPaused = !isPaused;
        mps.emit1(GameEvents.action, isPaused);
        _updatePause();
      }
      if (input.arrowLeft || input.isKey(LogicalKeyboardKey.keyA)) {
        movingLeft = false;
      } else if (input.arrowRight || input.isKey(LogicalKeyboardKey.keyD)) {
        movingRight = false;
      }
    });

    stage.keyboard.onDown.add((input) {
      if (input.arrowLeft || input.isKey(LogicalKeyboardKey.keyA)) {
        movingLeft = true;
      } else if (input.arrowRight || input.isKey(LogicalKeyboardKey.keyD)) {
        movingRight = true;
      }
      if (input.isKey(LogicalKeyboardKey.space)) {
        _resumeGame();
      }
    });

    // graphics
    //     .lineStyle(wallW, 0x00ff00)
    //     .drawRect(wallW / 2, wallW / 2, gameW - wallW, gameH - wallW)
    //     .endFill();

    graphics
        .beginFill(kColorBlack.withOpacity(.2))
        .drawRect(0, 0, gameW, gameH)
        .endFill();
    bicksContainer = GSprite();

    brickGap = 2;
    final bricksAreaW = gameW - wallW * 2;
    rows = kLevelData.length;
    cols = kLevelData[0].length;
    totalBrickSep = brickGap * (cols - 1);
    brickW = (bricksAreaW - totalBrickSep) / cols;
    brickH = brickW / 2;

    hud = HUD();
    paddle = Paddle();
    paddle.init(brickW * 2, brickH, Colors.white);

    ball = Ball();
    ball.init(3, 3, Colors.white);

    addChild(bicksContainer);
    addChild(paddle);
    addChild(ball);
    addChild(hud);
    _buildBricks();

    _newGame();

    paddle.x = gameW / 2 - paddle.w / 2;
    paddle.y = gameH - paddle.h - 10;

    alignPivot();
    stage.onResized.add(() {
      var graphBounds = bounds;
      var r1 = sw / sh;
      var r2 = graphBounds.width / graphBounds.height;
      if (r1 < r2) {
        width = sw;
        scaleY = scaleX;
      } else {
        height = sh;
        scaleX = scaleY;
      }
      setPosition(sw / 2, sh / 2);
    });
  }

  @override
  void update(double delta) {
    super.update(delta);
    if (isPaused) return;
    if (isDragging) {
      paddle.x = paddlePressX + (mouseX - stagePressX);
    } else {
      var thrust = stage.keyboard.isShiftPressed ? 2.0 : 1.0;
      if (movingLeft) {
        paddle.vx = -paddle.speed;
      } else if (movingRight) {
        paddle.vx = paddle.speed;
      } else {
        paddle.vx = 0;
      }
      paddle.x += paddle.vx * thrust;
    }

    if (paddle.x < wallW) {
      paddle.x = wallW;
    } else if (paddle.x > gameW - paddle.w - wallW) {
      paddle.x = gameW - paddle.w - wallW;
    }

    ball.x += ball.vx;
    ball.y += ball.vy;

    if (ball.x < wallW + ball.radius) {
      ball.x = wallW + ball.radius;
      ball.vx *= -1;
    } else if (ball.x > gameW - ball.radius) {
      ball.x = gameW - ball.radius;
      ball.vx *= -1;
    }

    if (ball.y < wallW + ball.radius) {
      ball.y = wallW + ball.radius;
      ball.vy *= -1;
    } else if (ball.y > gameH) {
      _loseLife();
    }

    if (collides(ball, paddle)) {
      ball.vy *= -1;
      ball.y = paddle.y - ball.radius;
    }

    final removeBricks = [];
    bricks.forEach((b) {
      if (!collides(b, ball)) return;
      removeBricks.add(b);
      hud.showPoints(b.points, b.getBounds(this));
      b.removeFromParent();

      /// check speed
      brokenBricksCount++;
      if (brokenBricksCount % ballSpeedUpMaxBricks == 0) {
        _increaseBallSpeed();
      }
      score += b.points;
      hud.setScore(score);
      final hitUp = ball.y + ball.radius - ball.vy <= b.y;
      final hitDown = ball.y + ball.radius - ball.vy >= b.y + b.h;
      if (hitUp) {
        ball.vy *= -1;
        ball.y += ball.vy;
      } else if (hitDown) {
        ball.vy *= -1;
        ball.y += ball.vy;
      } else {
        ball.x -= ball.vx;
        ball.vx *= -1;
      }
    });

    removeBricks.forEach((b) => bricks.remove(b));
    // removeBricks.forEach(bricks.remove);
    removeBricks.clear();

    if (bricks.isEmpty) {
      _winGame();
    }
  }

  bool collides(GDisplayObject obj1, GDisplayObject obj2) {
    var bounds1 = obj1.getBounds(this);
    var bounds2 = obj2.getBounds(this);
    return bounds1.intersects(bounds2);
  }

  void _resetBall() {
    ball.vx = ball.vy = 0;
    ball.setPosition(gameW * .3, gameH * .5);
  }

  double ballSpeedInc = 1.018;
  double maxBallSpeed = 4.0;
  int ballSpeedUpMaxBricks = 5;

  void _increaseBallSpeed() {
    if (ball.vx.abs() > maxBallSpeed) {
      return;
    }
    ball.vx *= ballSpeedInc;
    ball.vy *= ballSpeedInc;
    hud.speedUp();
  }

  bool isPaused = false;

  void _updatePause() {
    hud.showPause(isPaused);
    final ticker = stage.scene.core.ticker;
    if (isPaused) {
      ticker.callNextFrame(ticker.pause);
    } else {
      ticker.resume();
    }
  }
}
