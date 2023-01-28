/// made by roipeker 2020.

/// original video sample:
/// https://media.giphy.com/media/n7q53cJN2UuSu7EmN2/source.mp4

/// graphx demo version:
/// https://media.giphy.com/media/pKXa68pcv2H1dSjxYX/source.mp4
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene/scene.dart';

class ColorfulLoaderMain extends StatelessWidget {
  const ColorfulLoaderMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SceneBuilderWidget(
        builder: () => SceneController(
          front: ColorLoaderScene(),
          config: SceneConfig.autoRender,
        ),
        autoSize: true,
      ),
    );
  }
}
