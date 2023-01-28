/// roipeker 2020
///
/// simple flower opening.
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene.dart';

class FlowerGradientMain extends StatelessWidget {
  const FlowerGradientMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SceneBuilderWidget(
          builder: () => SceneController(
            front: FlowerScene(),
          ),
        ),
      ),
    );
  }
}
