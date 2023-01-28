/// roipeker 2020
///
/// As other samples, use the `SceneBuilderWidget`.
///
/// web demo: https://roi-graphx-balls-collision.surge.sh/#/
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene/scene.dart';

class BallVsLineMain extends StatelessWidget {
  const BallVsLineMain({super.key});

  @override
  Widget build(BuildContext context) {
    return SceneBuilderWidget(
      builder: () => SceneController(front: CollisionScene()),
      autoSize: true,
    );
  }
}
