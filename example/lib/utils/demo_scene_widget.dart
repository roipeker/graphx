import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class DemoSingleSceneWidget extends StatelessWidget {
  final Sprite root;
  final String title;
  final Widget child;
  final SceneConfig config;

  const DemoSingleSceneWidget({
    Key key,
    @required this.root,
    @required this.title,
    this.config,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? 'GraphX demo'),
      ),

      /// takes the entire body area.
      body: Center(
        child: SceneBuilderWidget(
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
