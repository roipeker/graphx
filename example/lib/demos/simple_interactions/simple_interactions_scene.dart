import 'package:graphx/graphx.dart';

import 'ui/my_button.dart';

class SimpleInteractionsScene extends SceneRoot {
  SimpleInteractionsScene() {
    config(
      useKeyboard: true,
      usePointer: true,
      autoUpdateAndRender: true,
    );
  }

  @override
  void addedToStage() {
    var button = MyButton();
    addChild(button);
    button.alignPivot();

    button.onMouseDown.add((e) => print("mouse down on button! $e"));

    stage.onResized.add(() {
      button.x = stage.stageWidth / 2;
      button.y = stage.stageHeight / 2;
    });
  }
}
