import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class DemoSingleSceneWidget extends StatelessWidget {
  final GSprite root;
  final Widget? child;
  final SceneConfig? config;
  final Color? color;

  const DemoSingleSceneWidget({
    super.key,
    required this.root,
    this.config,
    this.child,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: color ?? const Color.fromARGB(255, 255, 255, 255),
        child: SceneBuilderWidget(
          autoSize: true,
          builder: () => SceneController(
            back: root,
            config: config ?? SceneConfig.interactive,
          ),
          child: child,
        ),
      ),
    );
  }
}
