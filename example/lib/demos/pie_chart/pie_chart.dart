import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene.dart';

class PieChartMain extends StatelessWidget {
  const PieChartMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.grey.withOpacity(.06),
          width: 300,
          height: 300,
          child: SceneBuilderWidget(
            builder: () => SceneController(front: PieChartScene()),
          ),
        ),
      ),
    );
  }
}
