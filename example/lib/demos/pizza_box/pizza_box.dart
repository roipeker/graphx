/// roipeker 2021
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene.dart';

class PizzaBoxMain extends StatelessWidget {
  const PizzaBoxMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('pizza box'),
      // ),
      body: SizedBox.expand(
        child: SceneBuilderWidget(
          builder: () => SceneController(back: PizzaBoxScene()),
          autoSize: true,
        ),
      ),
    );
  }
}
