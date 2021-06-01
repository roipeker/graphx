import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'drawing_pad/draw_pad_scene.dart';
import 'pad_settings.dart';

class DrawingPadBezierMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        body: Stack(
          children: [
            SceneBuilderWidget(
              builder: () => SceneController(
                  back: DrawPadScene(), config: SceneConfig.tools),
            ),
            Positioned(left: 0, right: 0, bottom: 0, child: PadSettings()),
          ],
        ),
      ),
    );
  }
}
