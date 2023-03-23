import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'zoom_gesture_scene.dart';

///
/// based on gists: https://gist.github.com/roipeker/169351b6591ffaba82c88e8c3f90f167
/// live demo: https://graphx-gesture-simple.surge.sh
/// reference thread: https://github.com/roipeker/graphx/issues/19
///

class ZoomGestureMain extends StatefulWidget {
  const ZoomGestureMain({super.key});

  @override
  _ZoomGestureMain createState() => _ZoomGestureMain();
}

class _ZoomGestureMain extends State<ZoomGestureMain> {
  final scene = ZoomGestureScene();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onScaleStart: scene.onScaleStart,
        onScaleUpdate: scene.onScaleUpdate,
        child: SceneBuilderWidget(
          autoSize: true,
          builder: () => SceneController(front: scene),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scene.resetTransform,
        child: const Text('reset'),
      ),
    );
  }
}
