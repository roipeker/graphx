/// roipeker 2021
/// live demo:
/// https://graphx-mountain-chart.surge.sh/
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene/chart_scene.dart';

class ChartMountainMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 418,
          height: 255,
          child: SceneBuilderWidget(
            builder: () => SceneController(front: SampleMountainChart()),
          ),
        ),
      ),
    );
  }
}
