import 'package:graphx/graphx.dart';
import 'test_icons.dart';
import 'test_svg_scene.dart';

class SvgIconsScene extends Sprite {
  @override
  void addedToStage() {
    addChild(TestIcons());
    // addChild(TestSvgScene());
  }
}
