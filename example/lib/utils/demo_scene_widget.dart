import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class DemoSingleSceneWidget extends StatelessWidget {
  final SceneRoot sceneRoot;
  final String title;
  final Widget child;

  const DemoSingleSceneWidget({
    Key key,
    @required this.sceneRoot,
    @required this.title,
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
          builder: () => SceneController.withLayers(back: sceneRoot),
          child: child,
        ),
      ),
    );
  }
}
