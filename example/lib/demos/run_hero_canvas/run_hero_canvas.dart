/// roipeker 2020
///
/// custom painting sample.
/// Shows how to create your own DisplayObjects.
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene/hero_scene.dart';

class RunHeroCanvasMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      body: Center(
        child: Container(
          width: 500,
          height: 500,
          child: SceneBuilderWidget(
            builder: () => SceneController(
              front: PainterRawScene(),
              config: SceneConfig(
                autoUpdateRender: true,
                useKeyboard: true,
                usePointer: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
