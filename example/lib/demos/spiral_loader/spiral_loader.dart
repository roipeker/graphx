/// roipeker 2020
///
/// video demo: https://media.giphy.com/media/eT1pePI6NqpEg3rBmA/source.mov
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'spiral_loader_scene.dart';

class SpiralLoaderMain extends StatelessWidget {
  const SpiralLoaderMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 80,
                // color: Colors.red.withOpacity(.2),
                child: SceneBuilderWidget(
                  builder: () => SceneController(back: DnaScene()),
                ),
              ),
              const SizedBox(height: 8),
              const Text("Loading..."),
            ],
          ),
        ),
      ),
    );
  }
}
