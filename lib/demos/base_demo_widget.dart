import 'package:flutter/material.dart';
import 'package:graphx/graphx/graphx.dart';
import 'package:graphx/graphx/graphx_widget.dart';

import 'simple_game/simple_game_main.dart';

class DemoSceneTester extends StatelessWidget {
  final RootScene backScene;
  final RootScene frontScene;
  final Widget child;

  const DemoSceneTester({Key key, this.backScene, this.frontScene, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SceneBuilderWidget(
      usePointer: true,
      useKeyboard: true,
      builder: () => SceneController.withLayers(
        back: backScene,
        front: frontScene,
      ),
      child: child,
    );
  }
}
