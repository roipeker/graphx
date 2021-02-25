import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class Globe3dScene extends GSprite {
  List<double> vertices;
  List<double> uvData;
  List<int> indices;
  GSprite world;
  double centerZ = 500;
  int cols = 20, rows = 20;
  double fl = 1000;
  double radius = 400;
  double offset = 0;

  @override
  void addedToStage() {
    world = GSprite();
    addChild(world);
    loadStuff();
  }

  Future<void> loadStuff() async {
    await ResourceLoader.loadTexture(
        'assets/globe_3d/world_texture.jpg', 1, 'map');
    trace('map is:', ResourceLoader.getTexture('map'));
    makeTriangles();
    draw();
  }

  void makeTriangles() {
    indices = [];
    vertices = [];
    uvData = [];
    for (var i = 0; i < rows; ++i) {
      for (var j = 0; j < cols; ++j) {
        if (i < rows - 1 && j < cols - 1) {
          indices.addAll([
            i * cols + j,
            i * cols + j + 1,
            (i + 1) * cols + j,
          ]);
          indices.addAll([
            i * cols + j + 1,
            (i + 1) * cols + j + 1,
            (i + 1) * cols + j,
          ]);
        }
      }
    }
  }

  void draw() {
    var texture = ResourceLoader.getTexture('map');
    if (texture == null) return;

    offset -= .02;
    vertices.length = 0;
    uvData.length = 0;
    for (var i = 0; i < rows; ++i) {
      for (var j = 0; j < cols; ++j) {
        var angle = Math.PI * 2 / (cols - 1) * j;
        var angle2 = Math.PI * i / (rows - 1) - Math.PI / 2;
        var xpos = Math.cos(angle + offset) * radius * Math.cos(angle2);
        var ypos = Math.sin(angle2) * radius;
        var zpos = Math.sin(angle + offset) * radius * Math.cos(angle2);
        var scale = fl / (fl + zpos + centerZ);
        vertices.addAll([xpos * scale, ypos * scale]);
        uvData.addAll([j / (cols - 1), i / (rows - 1)]);
      }
    }
    world.graphics.clear();
    world.graphics.beginFill(Colors.black38);
    /// TODO: fix issues with z ordering.
    // world.graphics.beginBitmapFill(texture);
    world.graphics.lineStyle(0, Color(0xffff00ff));
    world.graphics.drawTriangles(
      vertices,
      indices,
      uvData,
      null,
      null,
    );
    world.graphics.endFill();
  }

  @override
  void update(double delta) {
    super.update(delta);
    world.setPosition(stage.stageWidth / 2, stage.stageHeight / 2);
    draw();
  }
}
