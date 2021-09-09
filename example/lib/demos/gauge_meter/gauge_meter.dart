/// roipeker 2020
///
/// video demo: https://media.giphy.com/media/rWF1Sc4CGLf3zfYlXn/source.mp4
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'gauge_scene.dart';

class GaugeMeterMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('graphx gauge meter')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SceneBuilderWidget(
          builder: () => SceneController(back: GaugeMeterScene()),
          autoSize: true,
        ),
      ),
    );
  }
}
