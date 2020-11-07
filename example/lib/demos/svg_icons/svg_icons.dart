import 'package:exampleGraphx/utils/utils.dart';
import 'svg_icons_scene.dart';

class DemoSvgIconsMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DemoSingleSceneWidget(
      title: 'svg & icon support',
      sceneRoot: SvgIconsScene(),
    );
  }
}
