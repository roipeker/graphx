import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class DemoSceneTester extends StatelessWidget {
  final SceneRoot backScene;
  final SceneRoot frontScene;
  final Widget child;

  const DemoSceneTester({Key key, this.backScene, this.frontScene, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SceneBuilderWidget(
//      usePointer: true,
//      useKeyboard: true,
//      isPersistentScene: false,
//      painterWillChange: true,
//      useTicker: false,
      builder: () => SceneController.withLayers(
        back: backScene,
        front: frontScene,
      ),
      child: child,
    );
  }
}
