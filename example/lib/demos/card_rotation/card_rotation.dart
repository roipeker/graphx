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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('3d card rotation')),
      body: Center(
        child: SceneBuilderWidget(
          builder: () => SceneController(
            front: CardRotation3dScene(),
          ),
        ),
      ),
    );
  }
}
