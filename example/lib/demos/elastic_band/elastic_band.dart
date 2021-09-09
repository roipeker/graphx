/// roipeker 2020
///
/// Simple elastic band effect with bezier curves.
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene.dart';

class ElasticBandMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('elastic band'),
        backgroundColor: kColorTransparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey.shade800,
      body: SizedBox.expand(
        child: SceneBuilderWidget(
          builder: () => SceneController(
            front: ElasticBandScene(),
          ),
        ),
      ),
    );
  }
}
