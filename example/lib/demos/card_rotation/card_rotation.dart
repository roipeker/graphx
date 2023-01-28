/// roipeker 2021

/// video demo:
/// https://media.giphy.com/media/18XFI8lY9Uj6cgoF66/source.mp4

/// web demo:
/// https://graphx-dropshadow-card.surge.sh/
///
import 'package:graphx/graphx.dart';

import '../../utils/utils.dart';
import 'scene.dart';

class CardRotation3dMain extends StatelessWidget {
  const CardRotation3dMain({super.key});

  @override
  Widget build(BuildContext context) {
    return SceneBuilderWidget(
      autoSize: true,
      builder: () => SceneController(
        front: CardRotation3dScene(),
      ),
    );
  }
}
