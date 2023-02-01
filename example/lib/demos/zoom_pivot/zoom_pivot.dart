import 'package:graphx/graphx.dart';

import '../../utils/utils.dart';
import 'zoom_pivot_scene.dart';

class ZoomPivotMain extends StatelessWidget {
  const ZoomPivotMain({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoSingleSceneWidget(
      // title: 'Transform (scale, rotate, move around pivot) a sprite',
      root: ZoomPivotScene(),
      config: SceneConfig(
        useKeyboard: true,
        usePointer: true,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Text('''
- Use your mouse or trackpad (scroll wheel) to test zoom+pan the box (accurate on macOS).

- Nested transformations are compatible.
                
'''),
          ],
        ),
      ),
    );
  }
}
