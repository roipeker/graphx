import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class DemoSingleSceneWidget extends StatelessWidget {
  final GSprite root;
  final String title;
  final Widget? child;
  final SceneConfig? config;

  const DemoSingleSceneWidget({
    Key? key,
    required this.root,
    required this.title,
    this.config,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),

      /// takes the entire body area.
      body: Center(
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

class ExampleInfo extends StatelessWidget {
  final String text;
  final Color? color;

  const ExampleInfo({Key? key, required this.text, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          text,
          style: TextStyle(color: color),
        ),
      ),
    );
  }
}
