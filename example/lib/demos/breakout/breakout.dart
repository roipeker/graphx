import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'hud_controls.dart';
import 'scene/game_scene.dart';

class BreakoutMain extends StatelessWidget {
  const BreakoutMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text('breakout'),
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        // ),
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(
            children: [
              Positioned.fill(
                child: SceneBuilderWidget(
                  builder: () => SceneController(
                    front: BreakoutAtari(),
                    config: SceneConfig.games,
                  ),
                ),
              ),
              const Positioned(
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
