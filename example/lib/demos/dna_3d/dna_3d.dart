/// copyright roipeker 2020
///
/// web demo:
/// https://roi-graphx-spiral3d.surge.sh
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene.dart';

class Dna3dMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DNA 2.5D')),
      body: SceneBuilderWidget(
        builder: () => SceneController(front: DnaScene()),
        autoSize: true,
      ),
    );
  }
}
