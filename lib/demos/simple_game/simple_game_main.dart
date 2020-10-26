import 'package:graphx/gameutils.dart';
import 'package:graphx/graphx/graphx.dart';
import 'package:graphx/graphx/utils/texture_utils.dart';

import 'game_world.dart';

class SimpleGameMain extends RootScene {
  static SimpleGameMain me;

  @override
  void init() {
    super.init();
    me = this;
    owner.core.config.useKeyboard = true;
    owner.core.config.useTicker = true;
    owner.needsRepaint = true;
  }

  GameWorld world;

  @override
  void ready() {
    super.ready();
    owner.core.resumeTicker();
    stage.onEnterFrame.add(onEnterFrame);
    stage.keyboard.onDown.add(onKeyboard);

    stage.color = 0xff000000;

    world = GameWorld();
    addChild(world);
    world.init();
  }

  void onEnterFrame() {
    world?.update();
  }

  void onKeyboard(KeyboardEventData e) {
    world?.handleKeyboard(e);
  }
}