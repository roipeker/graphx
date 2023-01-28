import 'package:graphx/graphx.dart';

import '../../utils/utils.dart';
import 'simple_interactions_scene.dart';

class SimpleInteractionsMain extends StatelessWidget {
  const SimpleInteractionsMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'For desktop, use keyboard to move ball, and mouse wheel on the weather icon',
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
        ),
        Expanded(
          child: DemoSingleSceneWidget(
            root: SimpleInteractionsScene(),
            config: SceneConfig(
              useKeyboard: true,
              usePointer: true,
            ),
          ),
        ),
      ],
    );
  }
}
