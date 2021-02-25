/// roipeker 2020
///
/// A grid of triangles/vertices with a mapped texture.
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene/scene.dart';

class TriGridMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('draw triangle grid'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SceneBuilderWidget(
          builder: () => SceneController(front: DrawTriangleGridScene()),
        ),
      ),
    );
  }
}
