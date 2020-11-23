import 'package:graphx/graphx.dart';
import 'test_icons.dart';

class SvgIconsScene extends Sprite {
  @override
  void addedToStage() {
    addChild(TestIcons());
//    addChild(TestSvgScene());
  }
}
