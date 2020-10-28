import 'package:flutter/material.dart';
import 'package:graphx/graphx/graphx_widget.dart';
import 'package:graphx/graphx/scene_controller.dart';

import 'audio_visual_main.dart';

class AudioVisualDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
//          width: 400,
//          height: 400,
//          color: Colors.grey,
          child: SceneBuilderWidget(
            builder: () => SceneController.withLayers(back: AudioVisualMain()),
          ),
        ),
      ),
    );
  }
}
