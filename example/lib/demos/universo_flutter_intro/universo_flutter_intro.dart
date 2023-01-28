/// roi 2020
/// video: https://media.giphy.com/media/ISiV2Jkiqn91N1kvqy/source.mp4
/// quick prototype for logo animation.
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene.dart';

class UniversoFlutterIntroMain extends StatelessWidget {
  const UniversoFlutterIntroMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          width: 600,
          height: 600,
          child: SceneBuilderWidget(
            builder: () => SceneController(back: UniversoFlutterScene()),
          ),
        ),
      ),
    );
  }
}
