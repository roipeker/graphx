import 'package:exampleGraphx/utils/utils.dart';

import 'simple_interactions_scene.dart';

class SimpleInteractionsMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DemoSingleSceneWidget(
      title: 'simple interactivity demo (pointer & keyboard support)',
      sceneRoot: SimpleInteractionsScene(),
    );
  }
}
