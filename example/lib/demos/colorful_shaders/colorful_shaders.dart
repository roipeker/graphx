import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'colorful_shaders_scene.dart';

class ColorfulShadersMain extends StatelessWidget {
  const ColorfulShadersMain({super.key});

  @override
  Widget build(BuildContext context) {
    return SceneBuilderWidget(
      builder: () => SceneController(front: ColorfulShadersScene()),
      autoSize: true,
    );
  }
}
