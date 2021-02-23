/// roipeker 2020
///
/// video demo: https://media.giphy.com/media/eT1pePI6NqpEg3rBmA/source.mov
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'spiral_loader_scene.dart';

class SpiralLoaderMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('spiral loader')),
      body: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 80,
                  // color: Colors.red.withOpacity(.2),
                  child: SceneBuilderWidget(
                    builder: () => SceneController(back: DnaScene()),
                  ),
                ),
                const SizedBox(height: 8),
                Text("Loading..."),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
