/// idea from: https://dribbble.com/shots/5215990-Submit-button-loading-animation
/// demo: https://graphx-submit-loading-btn.surge.sh/
import 'package:graphx/graphx.dart';

import 'my_button.dart';

class SubmitButtonScene extends GSprite {
  @override
  void addedToStage() {
    var btn = MyButton(stage!.stageWidth, stage!.stageHeight);
    addChild(btn);
  }
}
