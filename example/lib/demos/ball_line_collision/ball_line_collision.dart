/// roipeker 2020
///
/// As other samples, use the `SceneBuilderWidget`.
///
/// web demo: https://roi-graphx-balls-collision.surge.sh/#/
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene/scene.dart';

class BallVsLineMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ball vs line collisions')),
      body: SceneBuilderWidget(
        builder: () => SceneController(front: CollisionScene()),
      ),
    );
  }
}
