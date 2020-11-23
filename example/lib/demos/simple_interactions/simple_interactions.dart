import 'package:graphx/graphx.dart';

import '../../utils/utils.dart';

import 'simple_interactions_scene.dart';

class SimpleInteractionsMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DemoSingleSceneWidget(
      title: 'simple interactivity demo (pointer & keyboard support)',
      root: SimpleInteractionsScene(),
      config: SceneConfig(
        autoUpdateRender: true,
        useKeyboard: true,
        usePointer: true,
      ),
    );
  }
}
