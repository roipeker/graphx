import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import '../../utils/demo_scene_widget.dart';

class ConnectedMain extends StatelessWidget {
  const ConnectedMain({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoSingleSceneWidget(
      root: ConnectedScene(),
      config: SceneConfig.autoRender,
      color: const Color.fromARGB(255, 24, 24, 28),
    );
  }
}

class ConnectedScene extends GSprite {
  double get stageWidth => stage!.stageWidth;
  double get stageHeight => stage!.stageHeight;

  List<Node> nodes = [];

  // Get the number of balls to create based on the stage size.
  // if size is too small (<100) reduce it more.
  // take an average of 25pt per "node".
  int _axisCount(double value) => (value < 100 ? value * 0.6 : value) ~/ 25;

  @override
  void addedToStage() {
    super.addedToStage();
    _init(300);
  }

  void _onStageResize() {
    var total = _axisCount(stageWidth) * _axisCount(stageHeight);
    // clamp the total to a reasonable range.
    total = total.clamp(10, 750);
    // if the difference is too big, re-init the system.
    final difference = total - nodes.length;
    if (difference.abs() > 100) {
      _init(total);
    }
  }

  @override
  void update(double delta) {
    super.update(delta);
    _update(delta);
  }

  Future<void> _init(int count) async {
    nodes.clear();

    // Create some nodes
    for (int i = 0; i < count; i++) {
      final newNode = Node.create(width: stageWidth, height: stageHeight);
      nodes.add(newNode);
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

  void _update(double delta) {
    bool showSequentialLines = false;
    bool showNodes = true;
    bool showNearConnections = true;

    // Update all nodes
    for (Node node in nodes) {
      if (node.x < 0) {
        node.x = 0.0;
        node.xSpeed *= -1;
      } else if (node.x > stageWidth) {
        node.x = stageWidth;
        node.xSpeed *= -1;
      }

      if (node.y < 0) {
        node.y = 0.0;
        node.ySpeed *= -1;
      } else if (node.y > stageHeight) {
        node.y = stageHeight;
        node.ySpeed *= -1;
      }
      node.x += node.xSpeed;
      node.y += node.ySpeed;
    }

    graphics.clear();

    // Draw sequential lines
    if (showSequentialLines) {
      graphics.lineStyle(1, const Color.fromARGB(176, 64, 69, 132));
      graphics.moveTo(nodes[0].x, nodes[0].y);
      for (Node node in nodes) {
        graphics.lineTo(node.x, node.y);
      }
      graphics.endFill();
    }

    // Draw near connections
    if (showNearConnections) {
      for (var i = 0; i < nodes.length; i++) {
        var node = nodes[i];
        node.near = 0;
        const maxDistance = 60.0;
        for (var j = i + 1; j < nodes.length; j++) {
          final node2 = nodes[j];

          final distance =
              _distanceFast(node.x, node.y, node2.x, node2.y, maxDistance);
          // final distance = _distance(node.x, node.y, node2.x, node2.y);

          if (distance < maxDistance) {
            node.near++;
            final double thickness = 4 - 4 * (distance / maxDistance);
            final opacity = (1 - (distance / maxDistance)).clamp(0.0, 1.0);
            final Color color = Colors.white.withOpacity(opacity);

            graphics
                .lineStyle(thickness, color)
                .moveTo(node.x, node.y)
                .lineTo(node2.x, node2.y)
                .endFill();
          }
        }
      }
    }

    // Draw nodes (backgroundColor related to near count)
    if (showNodes) {
      for (Node node in nodes) {
        final Color fillColor = Color.lerp(
              const Color.fromARGB(255, 43, 137, 188),
              const Color.fromARGB(255, 255, 255, 0),
              min(node.near / 10, 1),
            ) ??
            node.color.withOpacity(0.25);
        final Color strokeColor = fillColor.withOpacity(0.5);

        graphics
            .beginFill(fillColor)
            .lineStyle(2, strokeColor)
            .drawCircle(node.x, node.y, node.radius)
            .endFill();
      }
    }
  }
}

class Node {
  late double x;
  late double y;
  late double radius;
  late Color color;
  int near = 0;

  late double xSpeed;
  late double ySpeed;
  late double lifespan;

  Node({
    double? x,
    double? y,
    double? radius,
    Color? color,
    double? xSpeed,
    double? ySpeed,
    double? lifespan,
  }) {
    this.x = x ?? 0.0;
    this.y = y ?? 0.0;
    this.radius = radius ?? 1.0;
    this.color = color ?? Colors.white;
    this.xSpeed = xSpeed ?? 1.0;
    this.ySpeed = ySpeed ?? 1.0;
    this.lifespan = lifespan ?? 10.0;
  }

  static Node create({
    required double width,
    required double height,
  }) {
    final x = Math.random() * width;
    final y = Math.random() * height;
    final double radius = Math.random() * 8 + 1;
    final scale = radius * 0.25;
    final xSpeed = Math.random() * scale - scale / 2;
    final ySpeed = Math.random() * scale - scale / 2;
    final ratio = radius / 16;
    final color = Color.lerp(
          const Color.fromARGB(255, 239, 220, 90),
          const Color.fromARGB(255, 241, 50, 50),
          ratio,
        ) ??
        Colors.red;

    return Node(
      x: x,
      y: y,
      radius: radius,
      color: color,
      xSpeed: xSpeed,
      ySpeed: ySpeed,
    );
  }
}
