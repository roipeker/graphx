/// copyright roipeker 2020
///
/// web demo:
/// https://roi-graphx-spiral3d.surge.sh
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene.dart';

class Dna3dMain extends StatelessWidget {
  const Dna3dMain({super.key});

  @override
  Widget build(BuildContext context) {
    return SceneBuilderWidget(
      builder: () => SceneController(front: DnaScene()),
      autoSize: true,
    );
  }
}
