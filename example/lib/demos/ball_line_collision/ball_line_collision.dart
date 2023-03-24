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
    return Container(
      decoration: const BoxDecoration(
        // color: Color.fromARGB(255, 176, 209, 234),
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 6, 4, 96),
            Color.fromARGB(255, 143, 212, 238)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SceneBuilderWidget(
        builder: () => SceneController(front: CollisionScene()),
        autoSize: true,
      ),
    );
  }
}
