import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'commands.dart';

class SnakeGameScene extends GSprite {
  static Color boardBorder = Colors.blue;
  static Color boardBackground = Color(0xFF989325);
  static Color snakeCol = Colors.black;
  static Color snakeBorder = Colors.green.withOpacity(.6);
  static Color foodCol = Color(0xFF443902);
  static Color foodBorder = Colors.transparent;

  GRect foodRect = GRect();

  double get sw => stage.stageWidth ?? 0;

  double get sh => stage.stageHeight ?? 0;

  GText scoreSt;
  final List<List<double>> snake = <List<double>>[
    [0, 0],
    [0, 0],
    [0, 0],
    [0, 0],
    [0, 0],
  ];

  static double tileSize = 24.0;
  int numCols = 0, numRows = 0, score = 0, frames = 0;
  double foodX = 0.0;
  double foodY = 0.0;
  double dx = tileSize;
  double dy = 0.0;
  bool changingDirection = false;

  final int speed;

  SnakeGameScene(this.speed);

  @override
  void addedToStage() {
    // stage.color = boardBackground;
    stage.maskBounds = true;
    mps.on('RESET', gameOver);
    mps.on('COMMAND', changeState);
    scoreSt = GText.build(
      text: 'SCORE: 0',
      fontSize: 20,
      fontFamily: 'pressstart',
      color: Colors.transparent,
      doc: this,
    );
    // stage.maskBounds = true;
    scoreSt.setPosition(20.0, 20.0);
    generateFood();
    resetSnake();
    stage.keyboard.onDown.add(onKeyDown);
  }

  @override
  void update(double delta) {
    super.update(delta);
    if (++frames % speed != 0) return;
    loop();
  }

  void resetSnake() {
    _computeGridSize();
    snake.clear();
    var startX = numCols ~/ 2 - 1;
    var startY = numRows ~/ 2 - 1;
    final slots = List<List<double>>.generate(
      5,
      (index) => [startX * tileSize - tileSize * index, startY * tileSize],
    ).toList();
    snake.addAll(slots);
    dx = tileSize;
    dy = 0.0;
  }

  void gameOver() {
    generateFood();
    resetSnake();
    score = 0;
    _updateScore();
  }

  void _updateScore() {
    scoreSt.text = 'SCORE: $score';
    mps.publish1('Score', scoreSt.text);
    scoreSt.validate();
  }

  void loop() {
    changingDirection = false;
    _computeGridSize();
    if (hasGameEnded()) {
      gameOver();
      return;
    }
    clearBoard();
    drawFood();
    drawSnake();
    drawFrame();
    moveSnake();
  }

  void drawFrame() {
    final lineW = 4.0;
    final lineW2 = lineW / 2;
    graphics.lineStyle(1, Colors.black26);
    graphics.drawRect(lineW2, lineW2, sw - lineW, sh - lineW);
    graphics.endFill();
  }

  void clearBoard() {
    graphics.clear();
    graphics.beginFill(boardBackground);
    graphics.drawRect(0, 0, sw, sh);
    graphics.endFill();
  }

  void drawSnake() {
    snake.forEach(drawSnakePart);
  }

  void drawSnakePart(List<double> snakePart) {
    graphics.beginFill(Colors.black38);
    graphics.lineStyle(1, Colors.white30);
    graphics.drawRect(snakePart[0], snakePart[1], tileSize, tileSize);
    graphics.endFill();
    graphics.endFill();
  }

  void drawFood() {
    if (isBig) {
      isPulsing = !isPulsing;
    } else {
      isPulsing = false;
    }

    final _foodCol = Colors.red.withOpacity(isPulsing ? 1 : .8);
    graphics.lineStyle(4, Colors.white54);
    graphics.beginFill(_foodCol);

    final inflation = isPulsing ? 0.0 : -2.0;
    final outRect = foodRect.clone().inflate(inflation, inflation);

    graphics.drawCircle(outRect.x + outRect.width / 2,
        outRect.y + outRect.height / 2, outRect.width / 2);

    graphics.endFill();
    graphics.endFill();
  }

  bool hasGameEnded() {
    for (var i = 4; i < snake.length; i++) {
      if (snake[i][0] == snake[0][0] && snake[i][1] == snake[0][1]) return true;
    }
    final hitLeftWall = snake[0][0] < 0;
    final hitRightWall = snake[0][0] > sw - tileSize;
    final hitToptWall = snake[0][1] < 0;
    final hitBottomWall = snake[0][1] > sh - tileSize;
    if (hitLeftWall) snake[0][0] = sw;
    if (hitRightWall) snake[0][0] = 0;
    if (hitToptWall) snake[0][1] = sh;
    if (hitBottomWall) snake[0][1] = 0;
    return false;
  }

  double randomFood(double min, double max) =>
      Math.randomRangeClamp(min, max, tileSize);

  void generateFood() {
    isBig = score % 8 == 0 && score > 0;
    foodX = randomFood(0, sw - tileSize);
    foodY = randomFood(0, sh - tileSize);
    final foodScale = isBig ? 2.0 : 1.0;
    foodRect.setTo(foodX, foodY, tileSize * foodScale, tileSize * foodScale);

    snake.forEach(hasSnakeEatenFood);
  }

  bool isBig = false;
  bool isPulsing = false;

  void hasSnakeEatenFood(List<double> part) {
    final hasEaten = foodRect.contains(part[0], part[1]);

    if (hasEaten) {
      generateFood();
    }
  }

  void _togglePause() {
    if (stage.controller.ticker.isTicking) {
      scoreSt.text = 'PAUSED';
      stage.controller.ticker.callNextFrame(() {
        stage.controller.ticker.pause();
      });
    } else {
      _updateScore();
      stage.controller.ticker.resume();
    }
    mps.publish1('Score', scoreSt.text);
  }

  void onKeyDown(KeyboardEventData event) {
    final key = event.rawEvent.logicalKey;
    if (key == Keys.LEFT_KEY) {
      changeState(SnakeCommands.left);
    }
    if (key == Keys.RIGHT_KEY) {
      changeState(SnakeCommands.right);
    }
    if (key == Keys.DOWN_KEY) {
      changeState(SnakeCommands.down);
    }
    if (key == Keys.UP_KEY) {
      changeState(SnakeCommands.up);
    }
    if (key == Keys.ESC_KEY) {
      changeState(SnakeCommands.pause);
    }
    if (key == Keys.R_KEY) {
      gameOver();
    }
  }

  void moveSnake() {
    final head = <double>[snake[0][0] + dx, snake[0][1] + dy];

    snake.insert(0, head);
    final hasEatenFood = foodRect.contains(snake[0][0], snake[0][1]);

    if (hasEatenFood) {
      if (score % 8 == 0 && score > 0) {
        score += 20;
      } else {
        score += 10;
      }

      _updateScore();

      generateFood();
    } else {
      snake.removeLast();
    }
  }

  void changeState([SnakeCommands command]) {
    if (command == SnakeCommands.pause) {
      _togglePause();
    }

    if (changingDirection) return;

    changingDirection = true;

    final goingUp = dy == -tileSize;
    final goingDown = dy == tileSize;
    final goingRight = dx == tileSize;
    final goingLeft = dx == -tileSize;
    if (command == SnakeCommands.left && !goingRight) {
      dx = -tileSize;
      dy = 0;
    }
    if (command == SnakeCommands.up && !goingDown) {
      dx = 0;
      dy = -tileSize;
    }
    if (command == SnakeCommands.right && !goingLeft) {
      dx = tileSize;
      dy = 0;
    }
    if (command == SnakeCommands.down && !goingUp) {
      dx = 0;
      dy = tileSize;
    }
  }

  void _computeGridSize() {
    numCols = sw ~/ tileSize;
    numRows = sh ~/ tileSize;
  }
}
