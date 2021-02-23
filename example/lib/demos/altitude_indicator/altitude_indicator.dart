import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import '../../utils/utils.dart';
import 'scene.dart';

class AltitudeIndicatorMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: SceneBuilderWidget(
            builder: () => SceneController(
              front: AltitudIndicatorScene(),
              config: SceneConfig.games,
            ),
          ),
        ),
      ),
    );
  }
}
