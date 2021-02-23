import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene/hue_scene.dart';
import 'scene/value_scene.dart';
import 'utils.dart';

class PickerContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const separator = SizedBox(width: 10);
    return Container(
      width: 450,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 24,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ValueListenableBuilder<Color>(
            valueListenable: pickerNotifier,
            builder: (ctx, value, _) => Container(
              width: 40,
              decoration: BoxDecoration(
                color: value,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
          ),
          separator,
          Expanded(
            child: Container(
              child: SceneBuilderWidget(
                builder: () => SceneController(front: ValueScene()),
              ),
            ),
          ),
          separator,
          Container(
            width: 80,
            child: SceneBuilderWidget(
              builder: () => SceneController(front: HueScene()),
            ),
          ),
        ],
      ),
    );
  }
}
