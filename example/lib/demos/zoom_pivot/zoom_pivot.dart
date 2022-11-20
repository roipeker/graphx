import 'package:exampleGraphx/utils/utils.dart';
import 'package:graphx/graphx.dart';

import 'zoom_pivot_scene.dart';

class ZoomPivotMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DemoSingleSceneWidget(
      title: 'Transform (scale, rotate, move around pivot) a sprite',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('''
- Use your mouse or trackpad (scroll wheel) to test zoom+pan the box (accurate on macOS).

- Nested transformations are compatible.
                
'''),
          ],
        ),
      ),
      root: ZoomPivotScene(),
      config: SceneConfig(
        autoUpdateRender: true,
        useKeyboard: true,
        usePointer: true,
      ),
    );
  }
}
