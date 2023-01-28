import 'package:graphx/graphx.dart';

import '../../utils/utils.dart';
import 'simple_interactions_scene.dart';

class SimpleInteractionsMain extends StatelessWidget {
  const SimpleInteractionsMain({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoSingleSceneWidget(
      root: SimpleInteractionsScene(),
      config: SceneConfig(
        useKeyboard: true,
        usePointer: true,
      ),
    );
  }
}
