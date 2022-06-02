import 'package:graphx/graphx.dart';

import 'exports.dart';

class SvgIconsScene extends GSprite {
  @override
  void addedToStage() {
    /// see how to render Svgs.
    addChild(TestSvgScene());

    /// see how to render Icons and assign Paint.
    addChild(TestIcons());
  }
}
