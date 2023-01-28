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
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'mouse repulsion',
          style: TextStyle(fontSize: 12),
        ),
        elevation: 0,
        backgroundColor: Colors.black26,
      ),
      body: Center(
        child: SceneBuilderWidget(
          builder: () => SceneController(front: MouseRepulsionScene()),
          autoSize: true,
        ),
      ),
    );
  }
}
