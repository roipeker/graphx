/// roipeker 2021.
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene/dripping_scene.dart';

class DrippingIVMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SceneBuilderWidget(
      builder: () => SceneController(back: DrippingScene()),
    );
  }
}
