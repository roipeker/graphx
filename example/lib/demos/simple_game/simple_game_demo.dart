import 'package:flutter/material.dart';
import 'package:graphx/graphx/widgets/graphx_widget.dart';
import 'package:graphx/graphx/core/scene_controller.dart';

import 'simple_game_main.dart';

class SimpleGameDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
//          width: 400,
//          height: 400,
//          color: Colors.grey,
          child: SceneBuilderWidget(
            builder: () => SceneController.withLayers(back: SimpleGameMain()),
          ),
        ),
      ),
    );
  }
}
