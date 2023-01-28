/// roipeker 2020
///
/// GraphX hover button line effect.
///
/// web demo:
/// https://roi-graphx-linebutton.surge.sh
///
/// source:
/// https://gist.github.com/roipeker/45bf283b37a3121e04c00aa0228e5dce
///
/// GraphX package: https://pub.dev/packages/graphx
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene.dart';

class LinedButtonMain extends StatelessWidget {
  const LinedButtonMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 140,
        height: 120,
        child: SceneBuilderWidget(
          builder: () => SceneController(front: LinedButtonScene()),
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     centerTitle: false,
    //     title: const Text(
    //       'graphx hover button',
    //       style: TextStyle(fontSize: 12),
    //     ),
    //     elevation: 0,
    //     backgroundColor: Colors.black.withOpacity(.1),
    //   ),
    //   body: Center(
    //     child: SizedBox(
    //       width: 140,
    //       height: 120,
    //       child: SceneBuilderWidget(
    //         builder: () => SceneController(front: LinedButtonScene()),
    //       ),
    //     ),
    //   ),
    // );
  }
}
