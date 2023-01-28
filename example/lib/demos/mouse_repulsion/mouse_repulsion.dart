/// roipeker 2020
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene.dart';

class MouseRepulsionMain extends StatelessWidget {
  const MouseRepulsionMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SceneBuilderWidget(
          builder: () => SceneController(front: MouseRepulsionScene()),
          autoSize: true,
        ),
      ),
    );
  }
}
