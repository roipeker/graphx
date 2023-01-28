/// roipeker 2021
///
/// idea from: https://dribbble.com/shots/7116566-Sorting-Button
/// demo: https://graphx-dropdown-4.surge.sh/
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene/scene.dart';

class SubmitButtonMain extends StatelessWidget {
  const SubmitButtonMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE3E3E3),
      body: Center(
        child: SizedBox(
          width: 298,
          height: 100,
          child: SceneBuilderWidget(
            builder: () => SceneController(front: SubmitButtonScene()),
          ),
        ),
      ),
    );
  }
}
