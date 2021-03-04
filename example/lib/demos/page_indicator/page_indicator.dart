/// roipeker 2020
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene.dart';

class PageIndicatorMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('page indicator'),
        elevation: 0,
        backgroundColor: Colors.black26,
      ),
      body: Center(
        child: Container(
          // width: 300,
          child: SceneBuilderWidget(
            builder: () => SceneController(
              front: PageIndicatorPaged(),
              config: SceneConfig.games,
            ),
          ),
        ),
      ),
    );
  }
}
