import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class DemoSingleSceneWidget extends StatelessWidget {
  final GSprite root;

  final Widget? child;
  final SceneConfig? config;

  const DemoSingleSceneWidget({
    super.key,
    required this.root,
    this.config,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SceneBuilderWidget(
        autoSize: true,
        builder: () => SceneController(
          back: root,
          config: config ?? SceneConfig.interactive,
        ),
        child: child,
      ),
    );
  }
}
