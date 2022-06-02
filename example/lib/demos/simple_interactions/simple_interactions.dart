import 'package:exampleGraphx/utils/utils.dart';
import 'package:graphx/graphx.dart';

import 'simple_interactions_scene.dart';

class SimpleInteractionsMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DemoSingleSceneWidget(
      title: 'simple interactivity demo (pointer & keyboard support)',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('''
- Use your keyboard arrows to move the red ball (press shift to move faster)
                
- Put mouse over the Temperature button, and use the mouse wheel to change the %
'''),
          ],
        ),
      ),
      root: SimpleInteractionsScene(),
      config: SceneConfig(
        autoUpdateRender: true,
        useKeyboard: true,
        usePointer: true,
      ),
    );
  }
}
