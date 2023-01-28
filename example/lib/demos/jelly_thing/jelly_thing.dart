/// made by roipeker 2020.
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene.dart';

class JellyThingMain extends StatelessWidget {
  const JellyThingMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            width: 400,
            height: 400,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(.2),
              borderRadius: BorderRadius.circular(60),
            ),
            child: SceneBuilderWidget(
              builder: () => SceneController(
                front: JellyDotsScene(),
                config: SceneConfig.games,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(32),
          child: const Text(
            'Move mouse around\n'
            '- Press R to reset the shape\n'
            '- Press D to show dots\n'
            '- Press O to show outline\n',
          ),
        ),
      ],
    );
  }
}
