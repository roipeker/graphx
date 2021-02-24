import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'hud_controls.dart';
import 'scene/game_scene.dart';

class BreakoutMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('breakout'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(
            children: [
              SizedBox(
                // width: 160,
                // height: 192,
                child: SceneBuilderWidget(
                  builder: () => SceneController(
                    front: BreakoutAtari(),
                    config: SceneConfig.games,
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: HUDControls(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
