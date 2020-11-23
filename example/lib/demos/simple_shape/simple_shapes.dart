import 'package:graphx/graphx.dart';

import '../../utils/utils.dart';

import 'simple_shapes_scene.dart';

class SimpleShapesMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DemoSingleSceneWidget(
      title: 'simple shapes drawing',
      root: SimpleShapesScene(),

      /// we are rendering a static scene here, no need for Ticker
      /// capabilities.
      config: SceneConfig.static,
    );
  }
}
