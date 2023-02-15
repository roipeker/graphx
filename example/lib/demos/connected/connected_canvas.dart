import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import '../../utils/demo_scene_widget.dart';

class ConnectedCanvasMain extends StatelessWidget {
  const ConnectedCanvasMain({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoSingleSceneWidget(
      root: ConnectedCanvasScene(),
      config: SceneConfig.autoRender,
      color: const Color.fromARGB(255, 24, 24, 28),
    );
  }
}

class ConnectedCanvasScene extends GSprite {
  double get stageWidth => stage!.stageWidth;

  double get stageHeight => stage!.stageHeight;

  List<SimpleBall> balls = [];

  final linePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  final ballPaint = Paint()..style = PaintingStyle.fill;

  // Get the number of balls to create based on the stage size.
  // if size is too small (<100) reduce it more.
  // take an average of 25pt per "node".
  int _axisCount(double value) => (value < 100 ? value * 0.6 : value) ~/ 25;

  @override
  void addedToStage() {
    super.addedToStage();
    stage!.onResized.add(_onStageResize);
    _init(300);
  }

  void _onStageResize() {
    var total = _axisCount(stageWidth) * _axisCount(stageHeight);
    // clamp the total to a reasonable range.
    total = total.clamp(10, 750);
    // if the difference is too big, re-init the system.
    final difference = total - balls.length;
    if (difference.abs() > 100) {
      _init(total);
    }
  }

  Future<void> _init(int count) async {
    balls.clear();
    for (int i = 0; i < count; i++) {
      balls.add(SimpleBall(width: stageWidth, height: stageHeight));
    }
  }

  // Eucledian distance formula
  double _distance(double x1, double y1, double x2, double y2) {
    return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
  }

  // Distance gross approximation
  double _distanceFast(
      double x1, double y1, double x2, double y2, double maxDistance) {
    final dx = (x1 - x2).abs();
    if (dx > maxDistance) {
      return maxDistance;
    }
    final dy = (y1 - y2).abs();
    if (dy > maxDistance) {
      return maxDistance;
    }
    return max(dx, dy);
  }

  @override
  void paint(Canvas canvas) {
    canvas.save();
    for (var i = 0; i < balls.length; i++) {
      var ball = balls[i];

      // Update with bounce
      if (ball.x < 0) {
        ball.x = 0.0;
        ball.xSpeed *= -1;
      } else if (ball.x > stageWidth) {
        ball.x = stageWidth;
        ball.xSpeed *= -1;
      }

      if (ball.y < 0) {
        ball.y = 0.0;
        ball.ySpeed *= -1;
      } else if (ball.y > stageHeight) {
        ball.y = stageHeight;
        ball.ySpeed *= -1;
      }

      balls[i].x += ball.xSpeed;
      balls[i].y += ball.ySpeed;

      // Draw near connections
      int near = 0;
      const maxDistance = 60.0;
      for (var j = i + 1; j < balls.length; j++) {
        final nextParticle = balls[j];

        final distance = _distanceFast(
            ball.x, ball.y, nextParticle.x, nextParticle.y, maxDistance);
        // final distance = dist(particle.x, particle.y, nextParticle.x, nextParticle.y);

        if (distance < maxDistance) {
          linePaint.color = const Color.fromARGB(255, 255, 255, 255)
              .withOpacity(1 - (distance / maxDistance));
          linePaint.strokeWidth = 4 - 4 * (distance / maxDistance);

          Offset point1 = Offset(ball.x, ball.y);
          Offset point2 = Offset(nextParticle.x, nextParticle.y);

          canvas.drawLine(point1, point2, linePaint);

          near++;
        }
      }

      // Particle color
      ballPaint.color = Color.lerp(
            const Color.fromARGB(255, 43, 137, 188),
            const Color.fromARGB(255, 255, 255, 0),
            min(near / 10, 1),
          ) ??
          Colors.red;

      // Draw particle
      canvas.drawCircle(
        Offset(ball.x, ball.y),
        ball.radius,
        ballPaint,
      );
    }
    canvas.restore();
  }
}

class SimpleBall {
  late double x;
  late double y;

  late double radius;
  late double xSpeed;
  late double ySpeed;

  SimpleBall({
    required double width,
    required double height,
  }) {
    x = Random().nextDouble() * width;
    y = Random().nextDouble() * height;

    radius = Random().nextDouble() * 8 + 2;

    xSpeed = Random().nextDouble() * 1.5 - 0.75;
    ySpeed = Random().nextDouble() * 1.0 - 0.5;
  }
}
