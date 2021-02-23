/// made by roipeker 2020.
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene.dart';

class JellyThingMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('jelly thing')),
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 400,
              height: 400,
              padding: EdgeInsets.all(8),
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
            padding: EdgeInsets.all(32),
            child: Text(
              'Move mouse around\n'
              '- Press R to reset the shape\n'
              '- Press D to show dots\n'
              '- Press O to show outline\n',
            ),
          ),
        ],
      ),
    );
  }
}
