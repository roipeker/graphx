import 'package:exampleGraphx/utils/utils.dart';

import 'simple_shapes_scene.dart';

class SimpleShapesMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DemoSingleSceneWidget(
      title: 'simple shapes drawing',
      sceneRoot: SimpleShapesScene(),
    );
  }
}
