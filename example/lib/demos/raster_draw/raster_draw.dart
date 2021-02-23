/// Note: Textures Images are not drawn in web targets.

/// video demo:
/// https://media.giphy.com/media/qPAkU7YV0S5zfxj6Cr/source.mov
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene.dart';

class RasterDrawMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('graphx drawing to bitmap')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SceneBuilderWidget(
          builder: () => SceneController(back: DrawingScene()),
        ),
      ),
    );
  }
}
