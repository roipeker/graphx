import 'package:graphx/graphx.dart';
import 'test_icons.dart';


class SvgIconsScene extends SceneRoot {
  SvgIconsScene() {
    config(autoUpdateAndRender: true);
  }

  @override
  void addedToStage() {
    addChild(TestIcons());
//    addChild(TestSvgScene());
  }
}
