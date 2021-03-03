/// roipeker 2020
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene.dart';

class LungsAnimationMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('lungs'),
        elevation: 0,
        backgroundColor: Colors.black26,
      ),
      body: Center(
        child: SceneBuilderWidget(
          builder: () => SceneController(front: LungsScene()),
        ),
      ),
    );
  }
}
