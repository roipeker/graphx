import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class DemoTriangles extends Sprite {
  DemoTriangles() {
    init();
  }

  void init() {}

  @override
  void $applyPaint() {
    super.$applyPaint();
    final positions = <double>[
      ...[10, 10, 100, 10, 10, 100, 100, 100],
    ];
    final indices = <int>[
      ...[0, 1, 2, 1, 3, 2],
    ];
    var vertices = Vertices.raw(
      VertexMode.triangles,
      Float32List.fromList(positions),
      indices: Uint16List.fromList(indices),
    );
    var fill = Paint();
    fill.color = Colors.orange;
    $canvas.drawVertices(vertices, BlendMode.src, fill);
  }
}
