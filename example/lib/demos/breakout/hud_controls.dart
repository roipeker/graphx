import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene/data.dart';
import 'scene/game_scene.dart';

class HUDControls extends StatelessWidget {
  const HUDControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Spacer(),
          buildButton(Icons.play_arrow_outlined, GameEvents.action),
        ],
      ),
    );
  }

  Widget buildButton(IconData ico, String eventType) {
    return MPSBuilder<bool>(
      topics: const [GameEvents.action],
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
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: const BoxDecoration(
              color: Colors.white10,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  spreadRadius: 0.5,
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white38,
              size: 24,
            ),
          ),
        );
      },
    );
  }
}
