import 'package:graphx/graphx.dart';

import '../../utils/utils.dart';

import 'simple_shapes_scene.dart';

class SimpleShapesMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DemoSingleSceneWidget(
      title: 'simple shapes drawing',
      root: SimpleShapesScene(),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('See how to draw basic shapes with GraphX'),
        ),
      ),

      /// we are rendering a static scene here, no need for Ticker
      /// capabilities.
      config: SceneConfig.static,
    );
  }
}
