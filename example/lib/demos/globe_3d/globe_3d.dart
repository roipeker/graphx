/// roipeker 2020
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene.dart';

class Globe3dMain extends StatelessWidget {
  const Globe3dMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SceneBuilderWidget(
          autoSize: true,
          builder: () => SceneController(front: Globe3dScene()),
        ),
      ),
    );
  }
}
