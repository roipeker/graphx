/// roipeker 2020
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene.dart';

class LungsAnimationMain extends StatelessWidget {
  const LungsAnimationMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SceneBuilderWidget(
        autoSize: true,
        builder: () => SceneController(front: LungsScene()),
      ),
    );
  }
}
