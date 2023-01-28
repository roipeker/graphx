import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'curved_graph_scene.dart';

class ChartBezierMain extends StatelessWidget {
  const ChartBezierMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('curved chart'),
      //   backgroundColor: Colors.transparent,
      // ),
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          width: 400,
          height: 300,
          child: SceneBuilderWidget(
            builder: () => SceneController(
              front: CurvedGraphScene(),
            ),
          ),
        ),
      ),
    );
  }
}
