import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene/data.dart';
import 'scene/game_scene.dart';

class HUDControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Spacer(),
          buildButton(Icons.play_arrow_outlined, GameEvents.action),
        ],
      ),
    );
  }

  Widget buildButton(IconData ico, String eventType) {
    return MPSBuilder<bool>(
      topics: [GameEvents.action],
      mps: mps,
      builder: (ctx, data, child) {
        final isPaused = BreakoutAtari.instance.isPaused;
        var icon = isPaused ? Icons.pause : Icons.play_arrow_outlined;
        return GestureDetector(
          onPanDown: (e) {
            mps.emit1(GameEvents.action, !isPaused);
          },
          child: Container(
            width: 48,
            height: 48,
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              icon,
              color: Colors.white38,
              size: 24,
            ),
            decoration: BoxDecoration(
              color: Colors.white10,
              shape: BoxShape.circle,
              boxShadow: [
                const BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  spreadRadius: 0.5,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
