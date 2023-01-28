/// Note: Textures Images are not drawn in web targets.

/// video demo:
/// https://media.giphy.com/media/qPAkU7YV0S5zfxj6Cr/source.mov
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene.dart';

class RasterDrawMain extends StatelessWidget {
  const RasterDrawMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SceneBuilderWidget(
        builder: () => SceneController(back: DrawingScene()),
        autoSize: true,
      ),
    );
  }
}
