/// roipeker 2020
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene.dart';

class PageIndicatorMain extends StatelessWidget {
  const PageIndicatorMain({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buildPageIndicator() {
      return Center(
        child: Container(
          width: 100,
          height: 20,
          padding: const EdgeInsets.all(4),
          color: Colors.grey.shade200,
          child: SceneBuilderWidget(
            builder: () => SceneController(
              front: PageIndicatorPaged(),
              config: SceneConfig.games,
            ),
            autoSize: true,
          ),
        ),
      );
    }

    /// sample 1, force the amount of Scenes to test
    // final body = SingleChildScrollView(
    //   child: Column(
    //     children: List.generate(10, (index) => buildPageIndicator()),
    //   ),
    // );

    /// sample 2, ListView builder lazily creates as you scroll.
    final body =
        ListView.builder(itemBuilder: (_, index) => buildPageIndicator());

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Text('page indicator (use keyboard Tab+arrows to move pages)'),
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}
