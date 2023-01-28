/// roipeker 2020
///
/// custom painting sample.
/// Shows how to create your own DisplayObjects.
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene/hero_scene.dart';

class RunHeroCanvasMain extends StatelessWidget {
  const RunHeroCanvasMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      body: Center(
        child: FittedBox(
          child: SizedBox(
            width: 500,
            height: 500,
            child: SceneBuilderWidget(
              builder: () => SceneController(
                front: PainterRawScene(),
                config: SceneConfig(
                  useKeyboard: true,
                  usePointer: true,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
