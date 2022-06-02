import 'package:graphx/graphx.dart';

import '../../utils/utils.dart';
import 'scene.dart';

class AltitudeIndicatorMain extends StatelessWidget {
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
                  padding: EdgeInsets.all(32),
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
              padding: EdgeInsets.all(8),
              child: Text('Use the arrows keys to rotate the plane and change altitude.'),
            )
          ],
        ),
      ),
    );
  }
}
