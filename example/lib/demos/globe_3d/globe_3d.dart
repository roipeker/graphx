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
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'globe 3d',
          style: TextStyle(fontSize: 12),
        ),
        elevation: 0,
        backgroundColor: Colors.black26,
      ),
      body: Center(
        child: SceneBuilderWidget(
          builder: () => SceneController(front: Globe3dScene()),
        ),
      ),
    );
  }
}
