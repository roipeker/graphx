/// roipeker 2021
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';
import 'scene.dart';

class PizzaBoxMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('pizza box'),
      ),
      body: SceneBuilderWidget(
        builder: () => SceneController(back: PizzaBoxScene()),
      ),
    );
  }
}
