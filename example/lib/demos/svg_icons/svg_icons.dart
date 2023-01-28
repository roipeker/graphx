import '../../utils/utils.dart';
import 'svg_icons_scene.dart';

class DemoSvgIconsMain extends StatelessWidget {
  const DemoSvgIconsMain({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoSingleSceneWidget(root: SvgIconsScene());
  }
}
