/// roipeker 2020
///
/// a cute feeling switch
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene.dart';

class FeelingSwitchMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'feeling switch',
          style: TextStyle(color: Colors.black26),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: SceneBuilderWidget(
            builder: () => SceneController(front: FeelingSwitch()),
            autoSize: true,
          ),
        ),
      ),
    );
  }
}
