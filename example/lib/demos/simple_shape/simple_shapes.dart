import 'package:graphx/graphx.dart';

import '../../utils/utils.dart';
import 'simple_shapes_scene.dart';

class SimpleShapesMain extends StatelessWidget {
  const SimpleShapesMain({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoSingleSceneWidget(
      root: SimpleShapesScene(),

      /// we are rendering a static scene here, no need for Ticker
      /// capabilities.
      config: SceneConfig.static,
    );
  }
}
