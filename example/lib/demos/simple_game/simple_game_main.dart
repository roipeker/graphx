
import 'package:graphx/graphx.dart';

import 'game_world.dart';

class SimpleGameMain extends SceneRoot {
  static SimpleGameMain me;

  @override
  void init() {
    super.init();
    me = this;
    scene.core.config.useKeyboard = true;
    scene.core.config.useTicker = true;
    scene.needsRepaint = true;
  }

  GameWorld world;

  @override
  void ready() {
    super.ready();
    scene.core.resumeTicker();
    ScenePainter.current.onUpdate.add(onEnterFrame);
//    stage.onEnterFrame.add(onEnterFrame);
    stage.keyboard.onDown.add(onKeyboard);

    stage.color = 0xff000000;

    world = GameWorld();
    addChild(world);
    world.init();
  }

  void onEnterFrame(double delta) {
    world?.update(delta);
  }

  void onKeyboard(KeyboardEventData e) {
    world?.handleKeyboard(e);
  }
}
