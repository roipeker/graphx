import 'package:graphx/graphx.dart';
import 'test_icons.dart';
// import 'test_svg_scene.dart';

class SvgIconsScene extends GSprite {
  @override
  void addedToStage() {
    addChild(TestIcons());
    // addChild(TestSvgScene());
  }
}
