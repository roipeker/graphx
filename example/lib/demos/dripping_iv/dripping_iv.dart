/// roipeker 2021.
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene/dripping_scene.dart';

class DrippingIVMain extends StatelessWidget {
  const DrippingIVMain({super.key});

  @override
  Widget build(BuildContext context) {
    return SceneBuilderWidget(
      builder: () => SceneController(back: DrippingScene()),
    );
  }
}
