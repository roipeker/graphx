import 'package:graphx/graphx.dart';

import '../../utils/utils.dart';
import 'scene.dart';

class AltitudeIndicatorMain extends StatelessWidget {
  const AltitudeIndicatorMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: Colors.black45,
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: SceneBuilderWidget(
                    builder: () => SceneController(
                      front: AltitudIndicatorScene(),
                      config: SceneConfig.games,
                    ),
                    autoSize: true,
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.grey.shade900,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: const Text('Use the arrows keys to rotated the plane.'),
            )
          ],
        ),
      ),
    );
  }
}
